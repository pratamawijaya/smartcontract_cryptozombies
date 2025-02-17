import { ConnectButton } from "@rainbow-me/rainbowkit";
import Image from "next/image";

export default function Home() {
  return (
    <main className="flex justify-center items-center w-screen h-screen">
      <ConnectButton />
    </main>
  );
}
