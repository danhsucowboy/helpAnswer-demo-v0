import Head from "next/head";
import { Image } from "@/component/Image";
import { useEffect, useState } from "react";
import { VStack, Text, Button, Box, useMediaQuery } from "@chakra-ui/react";
import { useRouter } from "next/router";

import {
  getAuth,
  signInWithPopup,
  signInWithRedirect,
  getRedirectResult,
  GoogleAuthProvider,
} from "firebase/auth";
import { firebaseApp } from "@/utils/firebaseConfig";

export default function Home() {
  const provider = new GoogleAuthProvider();
  const auth = getAuth(firebaseApp);
  const [isLargerThan768] = useMediaQuery("(min-width: 768px)");
  const router = useRouter();

  const handleLoginOnDeskTop = () => {
    signInWithPopup(auth, provider)
      .then((result) => {
        // This gives you a Google Access Token. You can use it to access the Google API.
        const credential = GoogleAuthProvider.credentialFromResult(result);
        const token = credential?.accessToken ?? "";
        // The signed-in user info.
        const user = result.user;
        //user.uid, displayname, email, photoURL

        console.log("credential", credential);
        console.log("token", token);
        console.log("user", user);

        router.push("today-you-want", undefined, { shallow: true });
      })
      .catch((error) => {
        // Handle Errors here.
        const errorCode = error.code;
        const errorMessage = error.message;
        // The email of the user's account used.
        const email = error.customData.email;
        // The AuthCredential type that was used.
        const credential = GoogleAuthProvider.credentialFromError(error);

        console.log("errorCode", errorCode);
        console.log("errorMessage", errorMessage);
        console.log("email", email);
        // ...
      });
  };

  const handleLoginOnMobile = async () => {
    await signInWithRedirect(auth, provider);

    try {
      const result = await getRedirectResult(auth);

      if (result) {
        // This gives you a Google Access Token. You can use it to access the Google API.
        const credential = GoogleAuthProvider.credentialFromResult(result);
        const token = credential?.accessToken ?? "";
        // The signed-in user info.
        const user = result.user;
        //user.uid, displayname, email, photoURL

        console.log("credential", credential);
        console.log("token", token);
        console.log("user", user);

        router.push("today-you-want", undefined, { shallow: true });
      }
    } catch (error: any) {
      // Handle Errors here.
      const errorCode = error.code;
      const errorMessage = error.message;
      // The email of the user's account used.
      const email = error.customData.email;
      // The AuthCredential type that was used.
      const credential = GoogleAuthProvider.credentialFromError(error);

      console.log("errorCode", errorCode);
      console.log("errorMessage", errorMessage);
      console.log("email", email);
      // ...
    }
  };

  return (
    <VStack
      w="full"
      h="70%"
      alignItems="center"
      justifyContent="center"
      spacing="0"
    >
      <Text
        fontSize={{ base: "4xl", md: "6xl" }}
        fontFamily="Montserrat"
        fontWeight="bold"
        color="white"
      >
        Help Answer
      </Text>
      <Text
        fontSize={{ base: "xs", md: "xl" }}
        fontFamily="Montserrat"
        color="white"
      >
        A help-to-earn, new type social platform
      </Text>
      <Box pt={{ base: "8", md: "12" }} pb="1">
        <Text
          fontSize={{ base: "xs", md: "md" }}
          fontFamily="Montserrat"
          color="white"
          fontWeight="200"
        >
          Welcome
        </Text>
      </Box>
      <Button
        size={{ base: "sm", md: "md" }}
        variant="solid"
        fontSize={{ base: "xs", md: "md" }}
        fontFamily="Montserrat"
        color="white"
        bgColor="blue.500"
        _hover={{ bgColor: "blue.600" }}
        onClick={handleLoginOnDeskTop}
      >
        Google Login
      </Button>
    </VStack>
  );
}
