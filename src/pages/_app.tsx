import "@/styles/globals.css";
import { ReactElement, ReactNode } from "react";
import Head from "next/head";
import type { NextPage } from "next";
import type { ErrorProps } from "next/error";
import type { AppProps } from "next/app";
import { ChakraProvider } from "@chakra-ui/react";
import { theme } from "../../theme";
import BaseLayout from "@/component/layouts/BaseLayout";

export type NextPageWithLayout<P = Record<string, unknown>, IP = P> = NextPage<
  P,
  IP
> & {
  getLayout?: (page: ReactElement) => ReactNode;
};

type AppPropsWithLayout = AppProps & {
  Component: NextPageWithLayout;
};

interface AppErrorProps extends ErrorProps {
  err?: Error;
  hasGetInitialPropsRun?: boolean;
}

export default function App({
  Component,
  pageProps,
  err,
}: AppPropsWithLayout & AppErrorProps) {
  const getLayout = Component.getLayout ?? ((page) => page);

  return (
    <>
      <Head>
        <title>HelpAnswer</title>
        <meta
          name="description"
          content="A help-to-earn, new type social platform, give a light to the lost you"
        />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <link rel="icon" href="/favicon.ico" />
      </Head>
      <ChakraProvider theme={theme}>
        <BaseLayout>
          {getLayout(<Component {...pageProps} err={err} />)}
        </BaseLayout>
      </ChakraProvider>
    </>
  );
}
