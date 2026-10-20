import numpy as np, pandas as pd
import matplotlib

matplotlib.use("Agg")
import matplotlib.pyplot as plt
from sklearn.preprocessing import StandardScaler
from sklearn.decomposition import PCA
from utils import ROOT, OUT, save


def run():
    d = pd.read_csv(ROOT / "data/input.csv")
    y = d.pop("Class")
    sc = StandardScaler()
    X = sc.fit_transform(d)
    p = PCA(n_components=0.9, svd_solver="full").fit(X)
    z = p.transform(X)
    rec = p.inverse_transform(z)
    OUT.mkdir(exist_ok=True)
    fig, ax = plt.subplots(1, 2, figsize=(11, 4))
    ax[0].plot(
        np.arange(1, len(p.explained_variance_ratio_) + 1),
        p.explained_variance_ratio_.cumsum(),
        marker="o",
    )
    ax[0].axhline(0.9, color="orange")
    ax[1].scatter(z[:, 0], z[:, 1], c=y, cmap="viridis")
    fig.tight_layout()
    fig.savefig(OUT / "pca.png")
    plt.close(fig)
    return save(
        dict(
            rows=len(X),
            features=X.shape[1],
            components_90=int(p.n_components_),
            retained_variance=float(p.explained_variance_ratio_.sum()),
            standardized_reconstruction_mse=float(np.mean((X - rec) ** 2)),
            scope="in-sample descriptive compression, not classification accuracy",
        )
    )


if __name__ == "__main__":
    run()
