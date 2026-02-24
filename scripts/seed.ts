import { PrismaClient } from '@prisma/client';
import { ethers } from 'ethers';

const prisma = new PrismaClient();

async function seed() {
  // Clear DB
  await prisma.node.deleteMany();
  await prisma.job.deleteMany();

  // Seed nodes
  await prisma.node.createMany({
    data: [
      { owner: '0x70997970C51812dc3A010C7d01b50e0d17dc79C8', type: 'gpu', status: 'active', stake: 10.5, reputation: 95, earnings: 1.24 },
      // ... add 10+ sample nodes
    ],
  });

  // Seed jobs
  await prisma.job.createMany({
    data: [
      { creator: '0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC', taskCID: 'QmExampleCID', payment: 0.42, status: 'open' },
      // ... add samples
    ],
  });

  console.log('Seed complete!');
}

seed().catch(console.error).finally(() => prisma.$disconnect());
