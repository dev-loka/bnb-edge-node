import type { Metadata } from "next";
import "./globals.css";
import { WalletProvider } from "@/components/WalletProvider";
import { Toaster } from "sonner";
import { Analytics } from "@vercel/analytics/react";

export const metadata: Metadata = {
    title: "BNB Edge Node OS",
    description: "DePIN Farm on opBNB",
};

export default function RootLayout({ children }: { children: React.ReactNode }) {
    return (
        <html lang="en">
            <body>
                <WalletProvider>
                    {children}
                    <Toaster />
                </WalletProvider>
                <Analytics />
            </body>
        </html>
    );
}
