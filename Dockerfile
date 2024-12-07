# build: docker buildx build --platform linux/amd64 -f Dockerfile -t wzdnzd/aggregator:tag --build-arg PIP_INDEX_URL="https://pypi.tuna.tsinghua.edu.cn/simple" .

FROM python:3.12.3-slim

LABEL maintainer="wzdnzd"

# github personal access token
ENV GIST_PAT="11BM7G7JI0hJ6CeB08ZppV_YzKgYmawAPBrfpwxpwsWPTPZGlgbc9WCueOcWVbFjvgNCD2V36W73XaTyh5"

# github gist info, format: username/gist_id
ENV GIST_LINK="tutatmp/49ce4a151e9eb3f68cd770dfefd01b8d"

# customize airport listing url address
ENV CUSTOMIZE_LINK=""

# pip default index url
ARG PIP_INDEX_URL="https://pypi.org/simple"

WORKDIR /aggregator

# copy files, only linux related files are needed
COPY requirements.txt /aggregator
COPY subscribe /aggregator/subscribe 
COPY clash/clash-linux-amd clash/Country.mmdb /aggregator/clash

COPY subconverter /aggregator/subconverter
RUN rm -rf subconverter/subconverter-darwin-amd \
    && rm -rf subconverter/subconverter-darwin-arm \
    && rm -rf subconverter/subconverter-linux-arm \
    && rm -rf subconverter/subconverter-windows.exe

# install dependencies
RUN pip install -i ${PIP_INDEX_URL} --no-cache-dir -r requirements.txt

# start and run
CMD ["python", "-u", "subscribe/collect.py", "--all", "--overwrite", "--skip"]
