To get the font:

1. Get the URL for the web font from the source of the Guardian website
2. Download the web font

    ```command
    curl -O https://assets.guim.co.uk/static/frontend/fonts/guardian-headline/noalts-not-hinted/GHGuardianHeadline-Bold.woff2
    ```

3. Install `woff2`

    ```command
    brew install woff2
    ```

4. Convert to TTF

    ```command
    woff2_decompress GHGuardianHeadline-Bold.woff2
    ```
