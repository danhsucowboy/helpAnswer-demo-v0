import { extendTheme } from "@chakra-ui/react";
import colors from "./foundations/colors";
import typography from "./foundations/typography";

export const theme = extendTheme({
  colors: {
    ...colors,
  },
  ...typography,
  fontSizes: {},
  radii: {
    "1": "0.25rem",
    "4": "1rem",
    "8": "2rem",
    "10": "2.5rem",
  },
  space: {
    "1.5": "0.375rem",
    "2.5": "0.625rem",
    "4": "1rem",
    "6": "1.5rem",
    "8": "2rem",
    "12": "3rem",
    "16": "4rem",
    "18": "4.5rem",
    "20.75": "5.1875rem",
    "30": "7.5rem",
    "32.75": "8.1875rem",
    "34.75": "8.6875rem",
    "45": "11.25rem",
    "65.5": "16.375rem",
  },
  sizes: {
    "5": "1.25rem",
    "8": "2rem",
    "9": "2.25rem",
    "14": "3.5rem",
    "19.5": "4.875rem",
    "24": "6rem",
    "37": "9.25rem",
    "48": "12rem",
    "52": "13rem",
    "85": "21.25rem",
    "85.75": "21.4375rem",
    "171": "42.75rem",
  },
});
