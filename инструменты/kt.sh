#!/usr/bin/env bash
set -e

if [ -z "$1" ] || [ -z "$2" ]; then
  echo "Использование: tools/new_kt.sh KTXX "Осмысленное название""
  exit 1
fi

KT_ID="$1"
KT_NAME="$2"

DIR="${KT_ID}-${KT_NAME// /-}"
mkdir -p "$DIR/src" "$DIR/data/raw" "$DIR/data/processed" "$DIR/screenshots"

# README
cat > "$DIR/README.md" <<'EOF'
# KTXX — Осмысленное название

## Цель
Кратко сформулируйте, что требуется по КТ.

## Данные
- Откуда взять данные / как воспроизвести.
- Что хранить в репозитории, а что — нет.

## Как запустить
```bash
# создать и активировать окружение (по желанию)
python -m venv .venv
# Windows: .venv\Scripts\activate
# Linux/Mac:
source .venv/bin/activate

pip install -r ../../requirements.txt

# запустить ноутбук
jupyter notebook report.ipynb
```

## Скриншоты
Поместите подтверждающие изображения в папку `screenshots/` и вставьте сюда:
![demo](screenshots/demo.png)

## Результаты
- Короткие выводы и полученные метрики/артефакты.

EOF

# notebook
python - <<'PY'
import nbformat as nbf, os, sys
nb = nbf.v4.new_notebook()
nb.cells = [
    nbf.v4.new_markdown_cell(f"# Report: {sys.argv[1]} — {sys.argv[2]}"),
    nbf.v4.new_code_cell("import numpy as np\nimport pandas as pd\nimport matplotlib.pyplot as plt\nprint('Готово: библиотеки импортированы')"),
    nbf.v4.new_markdown_cell("## Шаг 1. Загрузка/генерация данных"),
    nbf.v4.new_code_cell("df = pd.DataFrame({'x': range(10), 'y': [i**2 for i in range(10)]})\ndf.head()"),
    nbf.v4.new_markdown_cell("## Шаг 2. Визуализация результатов"),
    nbf.v4.new_code_cell("plt.plot(df['x'], df['y'])\nplt.title('Пример графика')\nplt.xlabel('x')\nplt.ylabel('y')\nplt.show()"),
    nbf.v4.new_markdown_cell("## Выводы\nКратко опишите выводы и что дальше.")
]
import json
with open(os.path.join(sys.argv[3], 'report.ipynb'), 'w', encoding='utf-8') as f:
    nbf.write(nb, f)
PY
