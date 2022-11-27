# ИДЗ №3 по АВС. Вариант №6, Семенов Никита БПИ214

## Условие задачи
>  Разработать программу, вычисляющую с помощью степенного ряда
с точностью не хуже 0,05% значение функции $\frac{1}{e^x}$ для заданного
параметра x.

## Отчет

Решение писалось сразу на 8 баллов. В отдельный модуль (`function.c`) выделена функция **f(x, eps)**, вычисляющая значение $\frac{1}{e^x}$ с точность до $eps$.

С потока входных файлов вводится одно вещественное число - параметр `x`. Остальные параметры (точность и количество повторений) передаются через флаги.

Функция в основном файле `main.c`
- **gen_double** - генерирует случайное вещественное число, генерируя отдельно целочисленные числетель(`[-1000; 1000]`) и знаменатель(`[1; 1001]`), используя *rand*.

Опции компиляции прописаны в Makefile'ах.

 Аргументы командной строки:
 - `<eps>` - требуемая точность;
 - `<iterations>` - количество повторений вычисления значения функции (для дольшего выполнения);
 - `-i` - ввод/вывод производится через консоль;
 - `-f <input-file> <output-file>` - ввод/вывод производится из файлов `input-file`/`output-file`;
- `-g <output-file>` - параметр $x$ генерируется функцией *gen_double*. Ответ записывается в файл.

Программа запускает функцию `f` `<iteration>` раз, и вычисляет время ее работы. Результат выводится в тактах и секундах.

Для удобства компиляции описан Makefile с таргетами `main`, `clear` и `run-tests`.

## На оценку 4-6

Добавлены комментарии для всех обращений к памяти и их соответствие переменным. В оптимизированной программе комментарии соответствующие реегистрам. Во всех функциях, включая main, убрано обращение на стек (кроме `x` для `scanf`). Все операнды инструкций хранятся в регистрах. Оптимизированные файлы находятс в папке `opt/`.

## На оценку 7

Реализован файловый ввод-вывод, который включается через флгаи. Прописана проверка корректности флагов. Тестовое покрытие описаное в отдельное разделе. Программа разбита на модули. 

## На оценку 8

Реализован генератор случайного вещественного числа - функция `gen_double(x, eps)`. Функция генерирует случайное вещественное число, генерируя отдельно целочисленные числетель(`[-1000; 1000]`) и знаменатель(`[1; 1001]`), используя *rand*. Функция `f` вычисляется `iterations` раз для более наглядной демонстрации времени работы программы оптимизированной и не оптимизированной программ. Тестирование описано в следующием разделе. 


## Тестирование

Для тестирования эквивалентности оптимизированной и сгенерированных программ, приведены 7 тестов с различными данными. В папке `tests/` расположены входные данные тестов. В папке `tests/output` расположены файлы результаты работы сгененерированного ассемблерного кода. В папке `tests/opt_output` расположены результаты работы оптимизированной ассемблерной программы.

Также сгенерированная и оптимизированная программы запускались c большим количеством повторений (функция считалась `1 000 000` раз). Как видно из тестов, разница в отдельных тестов (зависит от количество итераций при вычислении функции) разница в 3-4 раза.