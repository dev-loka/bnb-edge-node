import { NextResponse } from 'next/server';
import { db } from '@/db';
import { nodes } from '@/db/schema';

export async function GET() {
    try {
        const allNodes = await db.select().from(nodes);
        return NextResponse.json({ nodes: allNodes });
    } catch (error) {
        return NextResponse.json({ error: "Server error" }, { status: 500 });
    }
}
