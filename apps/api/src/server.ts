import express from "express";
import cors from "cors";
import { PrismaClient } from "@prisma/client";
import { createServer } from "http";
import { Server } from "socket.io";
import { publicClient } from "viem";
// import { opbnbTestnet } from "@bnb-edge/sdk";

const app = express();
app.use(cors());
app.use(express.json());

const prisma = new PrismaClient();
const server = createServer(app);
const io = new Server(server);

app.get("/rewards/:address", async (req, res) => {
    const address = req.params.address;
    const epoch = await prisma.epoch.findFirst({ orderBy: { id: "desc" } });
    if (!epoch) return res.status(404).json({ error: "No epoch" });
    const alloc = (epoch.allocations as any)[address.toLowerCase()];
    if (!alloc) return res.status(404).json({ error: "No reward" });
    res.json({ epoch: epoch.id, amount: alloc.amount, proof: alloc.proof });
});

// Add other routes: /nodes, /agents, /epochs, /governance

// Event indexer
async function indexEvents() {
    // Use viem to watch for events
    // publicClient.watchEvent({ ... })
}
indexEvents();

server.listen(4000, () => console.log("API on 4000"));
