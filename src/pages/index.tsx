import Head from "next/head";
import { Image } from "@/component/Image";
import { useEffect, useState } from "react";
import { VStack, Text, Button, Box } from "@chakra-ui/react";

export default function Home() {
  const [innerHeight, setInnerHeight] = useState<number>(0);

  useEffect(() => {
    setInnerHeight(window.innerHeight - 78);
  }, []);

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
      >
        Google Login
      </Button>
    </VStack>
  );
}
