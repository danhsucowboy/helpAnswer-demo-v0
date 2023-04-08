import { NextPage } from "next";
import { useEffect, useState } from "react";
import { VStack, Text, Button, Box, HStack } from "@chakra-ui/react";
import { useRouter } from "next/router";

const TodayYouWant: NextPage = () => {
  const router = useRouter();

  const handleSelectSeeker = () => {
    router.push("seeker", undefined, { shallow: true });
  };

  const handleSelectMaster = () => {
    router.push("master", undefined, { shallow: true });
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
        fontSize={{ base: "3xl", md: "6xl" }}
        fontFamily="Montserrat"
        fontWeight="bold"
        color="white"
      >
        Today, you want to...
      </Text>
      <HStack
        w="full"
        pt={{ base: "6", md: "9" }}
        pb={{ base: "1", md: "2" }}
        justifyContent="center"
      >
        <Text
          w="fit-content"
          fontSize={{ base: "xs", md: "lg" }}
          fontFamily="Montserrat"
          color="white"
          fontWeight="200"
          mr="3"
        >
          Please Select
        </Text>
      </HStack>
      <HStack
        w="full"
        justifyContent="center"
        alignItems="center"
        spacing={{ base: "8", md: "19" }}
      >
        <VStack w="50" alignItems="center" spacing="1">
          <Button
            w="full"
            h={{ base: "8", md: "12" }}
            variant="solid"
            fontSize={{ base: "xs", md: "md" }}
            fontFamily="Montserrat"
            color="white"
            bgColor="teal.500"
            _hover={{ bgColor: "teal.600" }}
            onClick={handleSelectSeeker}
          >
            Ask Questions
          </Button>
          <Text
            w="fit-content"
            fontSize={{ base: "xs", md: "sm" }}
            fontFamily="Montserrat"
            color="teal.500"
            fontWeight="200"
          >
            As a Seeker
          </Text>
        </VStack>
        <VStack w="50" alignItems="center" spacing="1">
          <Button
            w="50"
            h={{ base: "8", md: "12" }}
            variant="solid"
            fontSize={{ base: "xs", md: "md" }}
            fontFamily="Montserrat"
            color="white"
            bgColor="blue.500"
            _hover={{ bgColor: "blue.600" }}
            onClick={handleSelectMaster}
          >
            Listen Questions
          </Button>
          <Text
            w="fit-content"
            fontSize={{ base: "xs", md: "sm" }}
            fontFamily="Montserrat"
            color="blue.500"
            fontWeight="200"
          >
            As a Master
          </Text>
        </VStack>
      </HStack>
    </VStack>
  );
};

export default TodayYouWant;
