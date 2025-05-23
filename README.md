# リーマン予想の証明 プロジェクトへようこそ

このプロジェクトは、数学上の未解決問題であるリーマン予想の証明に挑戦するためのものです。
論文執筆には **LaTeX** を、数値計算やシミュレーションには **Python** を、そして数学的な証明の厳密な検証には **Lean** と **Coq** という証明支援系を使用します。

## このプロジェクトの構成 (フォルダ構成)

プロジェクト内の主なフォルダとファイルは以下の通りです。

```
RH-workspace/
├── .github/          # GitHub Actions の設定ファイル (自動化用)
│   └── workflows/
├── coq/              # Coq で書かれた証明のファイル (.v ファイル)
│   └── Dockerfile    # Coq を動かすための Docker 設定
├── figures/          # Python などで作った図 (グラフなど) の保存場所
├── lean/             # Lean で書かれた証明のファイル (.lean ファイル)
│   └── Dockerfile    # Lean を動かすための Docker 設定
├── listings/         # 論文に載せるプログラムコードの断片
├── python/           # Python スクリプト (.py ファイル)
│   └── Dockerfile    # Python を動かすための Docker 設定
├── sections/         # LaTeX の章や節ごとのファイル (例: example.tex)
├── tables/           # Python などで作った表のデータ (論文用)
├── .gitignore        # Git で管理しないファイルを指定
├── arxiv.sty         # arXiv 投稿用の LaTeX スタイルファイル
├── docker-compose.yml # 複数の Docker 環境をまとめて管理する設定ファイル
├── License.txt       # このプロジェクトのライセンス情報
├── main.tex          # 論文全体のメインとなる LaTeX ファイル
├── Makefile          # よく使うコマンドを短縮形で実行するためのファイル
├── orcid.pdf         # (サンプル) ORCID のアイコン
├── README.md         # このファイルです！プロジェクトの説明書
├── references.bib    # 参考文献リスト
└── template.tex      # (元にしたテンプレートファイル。削除してもOK)
```

## 最初に必要なもの (準備)

このプロジェクトを動かすためには、以下のソフトウェアが必要です。

- **Docker:** コンテナという仮想環境を作るためのツールです。 [公式サイト](https://www.docker.com/)
- **Docker Compose:** 複数の Docker コンテナをまとめて管理するためのツールです。 [公式サイト](https://docs.docker.com/compose/)
- **Make:** (任意) `Makefile` に書かれたコマンドを短い命令で実行できるようにするツールです。無くても個別の Docker コマンドで対応できます。

## プロジェクトの始め方 (セットアップ)

1.  **プロジェクトを自分の PC に持ってくる (Git を使う場合):**

    ```bash
    git clone <リポジトリのURL>
    cd RH-workspace
    ```

    `<リポジトリのURL>` は、このプロジェクトが置かれている場所の URL に置き換えてください。

2.  **Docker イメージを準備する:**
    ```bash
    docker-compose build
    ```
    このコマンドを実行すると、LaTeX、Python、Lean、Coq をそれぞれ動かすための専用環境 (Docker イメージ) があなたの PC 上に作られます。少し時間がかかる場合があります。

## プロジェクトの使い方

### 論文 (LaTeX) のコンパイル

- 論文の PDF ファイル (`main.pdf`) を作るには、ターミナルで以下のコマンドを実行します:

  ```bash
  make
  ```

  または、個別に Docker コマンドを実行する場合:

  ```bash
  docker-compose run --rm latex lualatex main.tex
  docker-compose run --rm latex bibtex main
  docker-compose run --rm latex lualatex main.tex
  docker-compose run --rm latex lualatex main.tex
  ```

  (`lualatex` を複数回実行するのは、相互参照や目次を正しく生成するためです。)

- コンパイル時に作られた中間ファイル (.aux, .log など) や PDF ファイルを消去するには:
  ```bash
  make clean
  ```

### Python スクリプトの実行

- Python スクリプトは `python/` フォルダに置きます。
- Python 環境には、数値計算ライブラリの `numpy`、`scipy`、グラフ描画ライブラリの `matplotlib` が最初から入っています。
- 例えば `python/my_simulation.py` というスクリプトを実行するには:
  ```bash
  make python SCRIPT=my_simulation.py
  ```
  または、直接 Docker コマンドで実行する場合:
  ```bash
  docker-compose run --rm python python my_simulation.py
  ```
- Python スクリプトから図や表を論文で使えるように、`figures/` フォルダや `tables/` フォルダに保存できます。

  **Python スクリプト内での記述例:**

  ```python
  import matplotlib.pyplot as plt
  import numpy as np

  # 簡単なグラフを作成
  x = np.linspace(0, 10, 100)
  y = np.sin(x)
  plt.plot(x, y)
  plt.title("サインカーブ")
  plt.xlabel("X軸")
  plt.ylabel("Y軸")
  # 図を figures/sine_wave.pdf として保存 (プロジェクトの figures フォルダに保存されます)
  plt.savefig("figures/sine_wave.pdf")

  # 簡単な表を作成 (例: LaTeX の表形式で tables/sample_table.tex に保存)
  table_data = """
  \\begin{tabular}{cc}
  項目A & 項目B \\\\ \hline
  1 & 2 \\
  3 & 4 \\
  \\end{tabular}
  """
  with open("tables/sample_table.tex", "w") as f:
      f.write(table_data)
  ```

### Lean による証明

- Lean のファイル (`.lean` 拡張子) は `lean/` フォルダに置きます。
- 例えば `lean/my_proof.lean` というファイルをコンパイル (チェック) するには:
  ```bash
  make lean FILE=my_proof.lean
  ```
  または、直接 Docker コマンドで実行する場合:
  ```bash
  docker-compose run --rm lean lean my_proof.lean
  ```
  (注: `lake` という Lean のプロジェクト管理ツールを使う場合は、`lake build` のようなコマンドをコンテナ内で実行するか、Makefile を調整する必要があります。)

### Coq による証明

- Coq のファイル (`.v` 拡張子) は `coq/` フォルダに置きます。
- 例えば `coq/my_theorem.v` というファイルをコンパイルするには:
  ```bash
  make coq FILE=my_theorem.v
  ```
  または、直接 Docker コマンドで実行する場合:
  ```bash
  docker-compose run --rm coq coqc my_theorem.v
  ```

## 結果を論文に含める方法

シミュレーション結果や証明コードなどを論文に取り込む方法です。

- **図 (Figures):**
  Python などで `figures/` フォルダに保存した図 (例: `figures/my_plot.pdf`) は、LaTeX 文書 (`main.tex` など) の中で以下のようにして貼り付けられます。

  ```latex
  \begin{figure}[htbp] % htbp は図の配置オプション
      \centering % 中央揃え
      \includegraphics[width=0.8\textwidth]{figures/my_plot.pdf} % 幅を本文の80%に
      \caption{この図の説明文}
      \label{fig:my_plot} % 参照用のラベル
  \end{figure}
  ```

- **表 (Tables):**
  Python などで `tables/` フォルダに `.tex` ファイルとして保存した表 (例: `tables/my_data_table.tex`) は、以下のようにして取り込めます。

  ```latex
  \begin{table}[htbp]
      \centering
      \input{tables/my_data_table.tex} % 外部ファイルを取り込む
      \caption{この表の説明文}
      \label{tab:my_data}
  \end{table}
  ```

- **プログラムコード (Code Listings):**
  Python の重要なアルゴリズムや、Lean/Coq の定理・定義などを `listings/` フォルダに個別のファイルとして保存 (例: `listings/my_algorithm.py`) しておくと、論文に綺麗に表示できます。

  Python コードの場合:

  ```latex
  \lstinputlisting[language=Python, caption={Pythonによるアルゴリズム}, label={lst:py_algo}]{listings/my_algorithm.py}
  ```

  Lean コードの場合:

  ```latex
  \lstinputlisting[language={[LaTeX]Lean}, caption={Leanによる定理}, label={lst:lean_thm}]{listings/my_theorem.lean}
  ```

  (注: `listings` パッケージが Lean の構文を標準でうまく解釈できない場合、`listings` の設定で Lean 用の言語定義を追加するか、Lean に適した別のパッケージを探す必要があるかもしれません。)

## プロジェクトへの貢献について

もしこのプロジェクトに協力してくださる方がいれば、(貢献に関するガイドラインがあればここに記述します)。

## ライセンス

このプロジェクトは [ライセンス名] のもとで公開されています。詳細は `License.txt` ファイルをご覧ください。
(まだライセンスを決めていない場合は、[Choose a License](https://choosealicense.com/) などを参考に選んでみてください)
