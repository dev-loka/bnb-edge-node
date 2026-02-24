"use client";

import Link from "next/link";
import { usePathname } from "next/navigation";

const links = [
    { href: "/", label: "Dashboard" },
    { href: "/farm", label: "DePIN Farm" },
    { href: "/agents", label: "AI Agents" },
    { href: "/nodes", label: "My Nodes" },
    { href: "/wallet", label: "Wallet" },
    { href: "/governance", label: "Governance" },
];

export function Sidebar() {
    const pathname = usePathname();
    return (
        <nav className="flex flex-col gap-4 p-4 bg-background border-r">
            {links.map((link) => (
                <Link
                    key={link.href}
                    href={link.href}
                    className={`p-2 rounded ${pathname === link.href ? "bg-accent" : ""}`}
                >
                    {link.label}
                </Link>
            ))}
        </nav>
    );
}
