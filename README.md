# Kijiji

## Build

```
docker build -t kijiji .
```

## Example

```
docker run --rm \
  -e PRICE_MIN=1500 \
  -e PRICE_MAX=3000 \
  -e RADIUS=10.0 \
  -e ADDRESS=M5G1P5 \
  -e LATITUDE=43.6534829 \
  -e LONGITUDE=-79.3862826 \
  -v ${PWD}:/root/workdir kijiji
```