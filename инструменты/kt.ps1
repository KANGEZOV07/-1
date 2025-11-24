param(
    [Parameter(Mandatory=$true)][string]$Id,
    [Parameter(Mandatory=$true)][string]$Name
)

$dir = "$Id-$($Name -replace ' ', '-')"
New-Item -ItemType Directory -Path "$dir/src","$dir/data/raw","$dir/data/processed","$dir/screenshots" -Force | Out-Null

# README
$readme = @"
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

"@
$readme | Out-File -FilePath "$dir/README.md" -Encoding utf8

# Notebook
python - <<'PY'
import nbformat as nbf, os, sys
kt_id, kt_name, kt_dir = sys.argv[1], sys.argv[2], sys.argv[3]
nb = nbf.v4.new_notebook()
nb.cells = [
    nbf.v4.new_markdown_cell(f"# Report: {kt_id} — {kt_name}"),
    nbf.v4.new_code_cell("import numpy as np\nimport pandas as pd\nimport matplotlib.pyplot as plt\nprint('Готово: библиотеки импортированы')"),
    nbf.v4.new_markdown_cell("## Шаг 1. Загрузка/генерация данных"),
    nbf.v4.new_code_cell("df = pd.DataFrame({'x': range(10), 'y': [i**2 for i in range(10)]})\ndf.head()"),
    nbf.v4.new_markdown_cell("## Шаг 2. Визуализация результатов"),
    nbf.v4.new_code_cell("plt.plot(df['x'], df['y'])\nplt.title('Пример графика')\nplt.xlabel('x')\nplt.ylabel('y')\nplt.show()"),
    nbf.v4.new_markdown_cell("## Выводы\nКратко опишите выводы и что дальше.")
]
with open(os.path.join(kt_dir, 'report.ipynb'), 'w', encoding='utf-8') as f:
    nbf.write(nb, f)
PY
