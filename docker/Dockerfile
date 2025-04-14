FROM julia:1.11.4

ENV JULIA_NUM_THREADS=2 \
    JULIA_PKG_SERVER="https://mirrors.cernet.edu.cn/julia" \
    JULIA_DEPOT_PATH="/opt/julia_depot" \
    PORT=9801 \
    APP_ROOT="/opt/Ai4EJuliaAPI"

RUN mkdir -p ${JULIA_DEPOT_PATH} ${APP_ROOT}

WORKDIR ${APP_ROOT}

COPY . .

RUN julia --project="." -e 'using Pkg; Pkg.instantiate(); include("srv/precompile.jl")'

EXPOSE $PORT

# ENTRYPOINT ["julia", "--project=/opt/Ai4EJuliaAPI", "srv/ai4ejuliaapi.jl"]

CMD ["bash"]