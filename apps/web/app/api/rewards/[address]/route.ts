import { NextResponse } from 'next/server';
import { db } from '@/db';
import { epochs } from '@/db/schema';
import { desc } from 'drizzle-orm';

export async function GET(request: Request, { params }: { params: { address: string } }) {
    const address = params.address.toLowerCase();

    try {
        const latestEpochs = await db.select().from(epochs).orderBy(desc(epochs.id)).limit(1);

        if (!latestEpochs.length) {
            return NextResponse.json({ error: "No epoch found" }, { status: 404 });
        }

        const epoch = latestEpochs[0];
        const allocations = epoch.allocations as any;
        const alloc = allocations[address];

        if (!alloc) {
            return NextResponse.json({ error: "No reward for this address" }, { status: 404 });
        }

        return NextResponse.json({
            epoch: epoch.id,
            amount: alloc.amount,
            proof: alloc.proof
        });
    } catch (error) {
        return NextResponse.json({ error: "Server error" }, { status: 500 });
    }
}
