import { ReactElement } from "react";
import {
  chakra,
  Image as ChakraImage,
  ImageProps as ChakraImageProps,
  ThemingProps,
  useStyleConfig,
} from "@chakra-ui/react";
import NextImage, { ImageProps as NextImageProps } from "next/legacy/image";
import { Sizes } from "../../theme/components/image";

// TODO review props when NextJs is updated so we don't have to defined it here
/**
 * ? Because NextJs typing is preventing auto-suggest for layout, width and height,
 * ? we declare the styles differently in this component and will manage the switch
 * ? to NextJs typings when calling NextJs `next/image` component
 */
type LayoutValue = "fixed" | "intrinsic" | "responsive" | undefined;

type LayoutAndSize =
  | {
      layout: "fill";
    }
  | {
      layout: LayoutValue;
      height: number;
      width: number;
    };

/**
 * Types for the Image component itself
 */
type ImageProps = Pick<
  NextImageProps,
  | "className"
  | "loading"
  | "objectFit"
  | "objectPosition"
  | "priority"
  | "quality"
  | "src"
  | "unoptimized"
> &
  Pick<Required<NextImageProps>, "alt"> &
  Pick<ThemingProps, "variant"> & {
    dimensions?: [number, number];
    layout?: "fill" | LayoutValue;
    sizes?: Sizes | string; // could be a string too, this one is just a way to make it easier
  };

/**
 * Wraps NextJs `next/image` component in Chakra's factory function
 * This is what will allow to use the theme and the styling properties on the component
 */
const ImageWithChakra = chakra(
  ({
    className,
    dimensions = [0, 0],
    layout = "fill",
    loading,
    objectFit,
    objectPosition,
    priority,
    quality,
    sizes,
    src,
    unoptimized,
    ...nextjsInternals
  }: ImageProps): ReactElement => {
    /**
     * ? As explained earlier, NextJs typing is preventing auto-suggest for layout, width and height
     * ? Here we actually convert our component typing to NextJs typing
     */
    const [width, height] = dimensions;

    const layoutAndSize: LayoutAndSize =
      height > 0 || width > 0
        ? {
            height,
            layout: layout === "fill" ? "intrinsic" : layout,
            width,
          }
        : {
            layout: "fill",
          };

    return (
      <ChakraImage
        width={width > 0 ? `${width}px` : undefined}
        height={height > 0 ? `${height}px` : undefined}
        className={className}
        src={src as string}
        objectFit={objectFit}
        objectPosition={objectPosition}
        {...nextjsInternals}
      />
    );

    return (
      <NextImage
        // placeholder="blur"
        className={className}
        loading={loading}
        objectFit={objectFit}
        objectPosition={objectPosition}
        priority={priority}
        quality={quality}
        sizes={sizes}
        src={src}
        unoptimized={unoptimized}
        // eslint-disable-next-line react/jsx-props-no-spreading
        {...layoutAndSize}
        // eslint-disable-next-line react/jsx-props-no-spreading
        {...nextjsInternals}
      />
    );
  }
);

export const Image = ({
  variant,
  ...props
}: ImageProps & ChakraImageProps): ReactElement => {
  /**
   * ? This components serves as an interface to pass Chakra's styles
   * ? You can use the theme and/or styling properties (eg. backgroundColor='red.200')
   */
  const styles = useStyleConfig("Image", { variant });
  // eslint-disable-next-line react/jsx-props-no-spreading
  return <ImageWithChakra sx={styles} {...props} />;
};
