import { create } from 'zustand';

interface AppState {
    walletAddress: string | null;
    setWalletAddress: (address: string) => void;
    txPending: boolean;
    setTxPending: (pending: boolean) => void;
    uiLoading: boolean;
    setUiLoading: (loading: boolean) => void;
}

export const useAppStore = create<AppState>((set) => ({
    walletAddress: null,
    setWalletAddress: (address) => set({ walletAddress: address }),
    txPending: false,
    setTxPending: (pending) => set({ txPending: pending }),
    uiLoading: false,
    setUiLoading: (loading) => set({ uiLoading: loading }),
}));
