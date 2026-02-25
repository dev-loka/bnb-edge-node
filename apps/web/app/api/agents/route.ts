import { NextResponse } from 'next/server';

export async function GET() {
    try {
        return NextResponse.json({ agents: [] });
    } catch (error) {
        return NextResponse.json({ error: "Server error" }, { status: 500 });
    }
}
