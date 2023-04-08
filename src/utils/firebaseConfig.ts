import { initializeApp } from "firebase/app";

const firebaseConfig = JSON.parse(
  process.env.NEXT_PUBLIC_FIREBASE_CONFIG ?? ""
);

export const firebaseApp = initializeApp(firebaseConfig);
