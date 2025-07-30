package main;

import com.seedfinding.mccore.rand.ChunkRand;
import com.seedfinding.mccore.util.block.BlockBox;
import com.seedfinding.mccore.util.pos.BPos;
import com.seedfinding.mccore.version.MCVersion;
import com.seedfinding.mcseed.lcg.LCG;
import kludwisz.generator.TrialChambersGenerator;
import kludwisz.generator.TrialChambersPieces;
import kludwisz.mineshafts.MineshaftGenerator;
import kludwisz.util.StructurePiece;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.stream.LongStream;

public class MainFindMineshaftAndTrialChamberLayout {

    public static final MCVersion VERSION = MCVersion.v1_21;

    public static void main(String[] args) {
        long maxState = (long)Math.ceil((1L << 48) * 0.004D); //mineshafts spawn when <0.004, will use this for nextDouble state prediction
        final long BLOCK = 268435456; //2^28
        long totalParts =  maxState/BLOCK; //loses some states at the end due to division remainder, oh well
        //totalParts -> 4194


        long startPart = 0;
        long endPart = totalParts;

        // Parse arguments if provided
        if (args.length >= 2) {
            try {
                startPart = Long.parseLong(args[0]);
                endPart = Long.parseLong(args[1]);
            } catch (NumberFormatException e) {
                System.err.println("Invalid arguments. Please provide integers for startPart and endPart.");
                System.exit(1);
            }
        }


        LongStream.range(startPart , endPart).parallel().forEach(part -> {
            LCG back1 = LCG.JAVA.combine(-1);
            ChunkRand rand = new ChunkRand();

            for (long state = (part)*BLOCK; state <= (1+part)*BLOCK; state++) {
                //nextDouble state prediction, gives a carverSeed that basically always guarantees a mineshaft spawn
                long carverSeed = back1.nextSeed(state) ^ LCG.JAVA.multiplier;
                checkCarverSeed(carverSeed, rand);
            }

        });
    }

    public static void checkCarverSeed(long seed, ChunkRand rand) {
        rand.setSeed(seed);

        //due to nextDouble state prediction its basically guaranteed to be <0.004 so we be cool and don't even check :) and advance 2 instead
        rand.advance(2);
        /*
        if (rand.nextDouble() > 0.004D) {
            return;
        }
        */


        //generate full mineshaft layout to get all chestPositions
        ArrayList<StructurePiece> pieces = new ArrayList<>();
        MineshaftGenerator.generate(rand, 0, 0, false, VERSION, pieces);

        ArrayList<BPos> chestPositions = new ArrayList<>();

        for (StructurePiece piece : pieces) {
            if (!(piece instanceof MineshaftGenerator.MineshaftCorridor corridor)) {
                continue;
            }
            chestPositions.addAll(corridor.getPossibleChestPositions());
        }


        //check max amount of chests that could potentially spawn in the same xz column
        Map<Long, Integer> countMap = new HashMap<>();
        int maxCount = 0;

        for (BPos pos : chestPositions) {
            int x = pos.getX();
            int z = pos.getZ();

            long key = (((long) x) << 32) | (z & 0xFFFFFFFFL);

            int count = countMap.getOrDefault(key, 0) + 1;
            countMap.put(key, count);

            if (count > maxCount) {
                maxCount = count;
            }
        }
        if(maxCount<5) {
            return;
        }

        // get all BPos part of the max column
        long maxKey = 0L;
        ArrayList<BPos> positions = new ArrayList<>();
        for (Map.Entry<Long, Integer> entry : countMap.entrySet()) {
            if (entry.getValue() == maxCount) {
                maxKey = entry.getKey();
                break;
            }
        }
        for (BPos pos : chestPositions) {
            long key = (((long) pos.getX()) << 32) | (pos.getZ() & 0xFFFFFFFFL);
            if (key == maxKey) {
                positions.add(pos);
            }
        }

        //determine lowest & highest minecart chest in column
        BPos lowestPos = null;
        BPos highestPos = null;
        for (BPos pos : positions) {
            if (lowestPos == null || pos.getY() < lowestPos.getY()) {
                lowestPos = pos;
            }
            if (highestPos == null || pos.getY() > highestPos.getY()) {
                highestPos = pos;
            }
        }


        // check if trial chamber layout in this chunk will generate air at the position of the potential cheststack column
        TrialChambersPieces.Piece goodPiece = null;
        TrialChambersGenerator trialChambersGen = new TrialChambersGenerator();

        // kinda misusing the method here with small trick
        // if you pass in a carverseed as the worldseed and the chunk 0,0 it generates layout for a carverseed
        // possible because for chunk 0,0 in any world the carverseed equals worldseed
        trialChambersGen.generate(seed, 0, 0, rand);
        for (TrialChambersPieces.Piece piece : trialChambersGen.pieces) {
            if(piece.getName().contains("intersection_3")) { // intersection_3 piece has the tallest air column
                BlockBox box = new BlockBox(piece.box.minX+3, piece.box.minY, piece.box.minZ+3, piece.box.maxX-3, piece.box.maxY, piece.box.maxZ-3);
                if(box.intersectsXZ(lowestPos.getX(), lowestPos.getZ(), lowestPos.getX(), lowestPos.getZ())) {
                    goodPiece = piece;
                }
                break;
            }
        }
        if(goodPiece==null) {
            return;
        }


        //probably should have added a height check somewhere to see if the chest column fits in the trial chamber height wise but decided i was too lazy


        System.out.println(seed);
        System.out.println("chest stack: " + maxCount);
        System.out.println("chests ranging from " + lowestPos.getY() + " to " + highestPos.getY());
        System.out.println("/tp " + lowestPos.getX() + " 40 " + lowestPos.getZ());
        System.out.println(goodPiece.box);
        System.out.println();
    }
}