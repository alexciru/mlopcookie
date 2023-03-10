FROM python:3.9-slim

RUN apt update && \
    apt install --no-install-recommends -y build-essential gcc && \
    apt clean && rm -rf /var/lib/apt/lists/*

COPY requirements.txt requirements.txt
COPY setup.py setup.py
COPY mlops_cc/ mlops_cc/
COPY data/ data/
COPY reports/ reports/
COPY models/ models/

WORKDIR /
RUN pip install --upgrade pip

RUN pip install -r requirements.txt --no-cache-dir
# torch cpu requires special command
RUN pip install torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cpu

# and finally our own module
RUN pip install -e .

ENTRYPOINT ["python", "-u", "mlops_cc/models/train_model.py"]

# ENTRYPOINT ["/bin/bash"]