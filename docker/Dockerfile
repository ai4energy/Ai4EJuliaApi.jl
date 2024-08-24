FROM julia:1.9.2


ENV JULIA_NUM_THREADS=2

WORKDIR /opt/ai4ejuliaapi/

COPY .. .

RUN julia --project="." -e 'ENV["JULIA_PKG_SERVER"] = "https://mirrors.pku.edu.cn/julia"; import Pkg; Pkg.instantiate();'

RUN julia --project="." precompile.jl

EXPOSE 19801

CMD ["bash"]