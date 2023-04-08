import { useEffect, useState } from "react";
import { Box, VStack, HStack, Button, Text } from "@chakra-ui/react";
import { Image } from "@/component/Image";

export default function BaseLayout({
  children,
}: {
  children?: React.ReactNode;
}) {
  const [innerHeight, setInnerHeight] = useState<number>(0);

  useEffect(() => {
    setInnerHeight(window.innerHeight);
  }, []);

  return (
    <Box
      as="main"
      w={{ base: "full" }}
      h={{ base: innerHeight ?? "full" }}
      bgColor="helpAnswerBg"
    >
      <HStack w="full" p="6" height="19.5">
        <Image
          src="/logo/thankyou-token-silver.png"
          alt="HelpAnswerLogo"
          width={{ base: "6", md: "10" }}
          height={{ base: "6", md: "10" }}
        />
        <Text
          fontSize={{ base: "xl", md: "3xl" }}
          fontFamily="Montserrat"
          fontWeight="bold"
          color="white"
        >
          HelpAnswer
        </Text>
      </HStack>
      {children}
    </Box>
  );
}
