 ## Project Overview

This repo contains the code and data used to forecast the 2024 U.S. Presidential Election. It was created by Talia Fabregas, Fatimah Yunusa, and Aamishi Sundeep Avarsekar. Its purpose is to put together a paper that discusses the results of the logistic regression model that we built and and the multi-level regression with post-stratification (MRP) that we performed to predict the popular vote and electoral college in the 2024 U.S. presidential election. The data that we used cannot be shared publicly, but we outline how we obtained it below.

- The survey data is from the Polarization Research Lab. We used the America's Political Pulse Survey Week 3 2024 data set. It can be found using the following link: https://polarizationresearchlab.org/americas-political-pulse/
- The post-stratification data is from IPUMS. It is a subset of the American Communitities Survey (ACS) 2022. It can be found using the following link: https://usa.ipums.org/usa/

## File Structure

The repo is structured as:

-   `data` contains the simulated data.
-   `models` contains the logistic regression model that we used to predict vote preference. 
-   `other` contains details about LLM (ChatGPT 3.5) interactions, and sketches of a potential dataset and graphs.
-   `paper` contains the files used to generate the paper, including the Quarto document and reference bibliography file, as well as the PDF of the paper. 
-   `scripts` contains the R scripts used to simulate, download, clean, and test data.


## Statement on LLM usage

Aspects of the code, including data visualizations, tests, and `references.bib` file, were written and debugged with the help of an LLM, ChatGPT 3.5. The interactions with ChatGPT 3.5 are available in `other/llm/usage.txt`. 
