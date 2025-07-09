# Ubuntu 22.04 (Jammy Jellyfish)를 베이스 이미지로 사용
FROM ubuntu:22.04

# 환경 변수 설정 (옵션)
ENV DEBIAN_FRONTEND=noninteractive

# 시스템 업데이트 및 필요한 도구 설치
# sudo, curl, wget, git, ca-certificates, fontconfig 등 기본 도구를 설치합니다.
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    sudo \
    curl \
    wget \
    git \
    ca-certificates \
    fontconfig \
    locales \
    # 추가: Noto CJK 폰트 패키지 설치 <- 이 부분 제거 또는 주석 처리
    # fonts-noto-cjk \
    # 추가: 시스템 폰트 유틸리티
    # fc-cache와 같은 명령어를 제공합니다.
    fontconfig \
    && \
    rm -rf /var/lib/apt/lists/*

# 한국어 로케일 설정 (Noto CJK 폰트 사용을 위해 권장)
ENV LANG=ko_KR.UTF-8
ENV LANGUAGE=ko_KR:en
ENV LC_ALL=ko_KR.UTF-8

# Pixi 설치
RUN curl -fsSL https://pixi.sh/install.sh | bash
ENV PATH="/root/.pixi/bin:${PATH}"

# Quarto 프로젝트를 위한 작업 디렉토리 생성
WORKDIR /app

# Pixi 환경 설정 (pixi.toml 및 pixi.lock 파일이 /app에 있다고 가정)
COPY pixi.toml pixi.lock ./
# Pixi를 통해 font-ttf-noto-cjk를 설치해도 되지만,
# fonts-noto-cjk APT 패키지를 직접 설치하여 시스템 전반에서 인식되도록 하는 것이 더 견고할 수 있습니다.
# 만약 pixi.toml에 font-ttf-noto-cjk가 있다면, 이 라인은 유지해도 됩니다.
RUN pixi install --frozen

# TinyTeX 설치 (Quarto를 통해)
RUN pixi run quarto install tool tinytex

# 폰트 캐시 업데이트 <- 이 부분 제거 또는 주석 처리
# 시스템에 새로 설치된 폰트를 인식하도록 폰트 캐시를 업데이트합니다.
# RUN sudo fc-cache -fv

# Quarto 프로젝트를 렌더링하는 예시 (컨테이너 시작 시 자동으로 실행)
COPY mybook/ ./mybook/
CMD cd mybook && pixi run quarto render --to pdf