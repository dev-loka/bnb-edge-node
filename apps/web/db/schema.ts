import { pgTable, text, timestamp, integer, bigint, jsonb } from 'drizzle-orm/pg-core';

export const nodes = pgTable('nodes', {
    id: text('id').primaryKey(),
    owner: text('owner').notNull(),
    nodeType: text('nodeType').notNull(),
    ipfsSpecCID: text('ipfsSpecCID').notNull(),
    stake: bigint('stake', { mode: 'number' }).notNull(),
    reputation: integer('reputation').notNull(),
    lastHeartbeat: bigint('lastHeartbeat', { mode: 'number' }).notNull(),
    slashed: integer('slashed').notNull().default(0),
    createdAt: timestamp('createdAt').defaultNow().notNull(),
    updatedAt: timestamp('updatedAt').defaultNow().notNull(),
});

export const epochs = pgTable('epochs', {
    id: integer('id').primaryKey(),
    root: text('root').notNull(),
    totalAmount: bigint('totalAmount', { mode: 'number' }).notNull(),
    ipfsCID: text('ipfsCID').notNull(),
    timestamp: bigint('timestamp', { mode: 'number' }).notNull(),
    allocations: jsonb('allocations').notNull(),
});
