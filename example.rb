# библиотека для временного файла
require 'tempfile'
# библиотека для работы с файлами
require 'fileutils'

class Example

    def self.process(file1, file2)
        # конвертируем путь к файлам в строку
        file1 = file1.to_s
        file2 = file2.to_s

        # проверяем существование исходных файлов 
        if File.exist?(file1) && File.exist?(file2)
            # Открываем каждый файл и читаем по одинаковому лайну из файла
            # Необходимо чтобы исходные файлы содержали одинаковое количество строк 
            # и не содержали пустые строки
            File.open(file1).zip(File.open(file2).each).each do |line1, line2|
                # сортируем числа из каждого лайна
                sorting(line1.to_i, line2.to_i)
            end
        else 
            puts "File not exist"
        end 
    end

    # сортировка чисел
    def self.sorting(first, second)
        # упорядочиваем числа по возрастанию
        first, second = second, first if first > second 
        # проверяем существует ли файл с результатами и пустой ли он 
        if File.exist?('data/1.txt') && File.zero?('data/1.txt') 
            # первоначальная запись для пустого файла
            File.open('data/1.txt', 'w+') do |file|
                # записывам в файл с результатами два упорядоченных первых числа 
                file.puts(first)
                file.puts(second)
            end
        elsif File.exist?('data/1.txt')
            # числа с каждого лайна записываются в результирующий файл
            [first, second].each do |num|
                # сортировка и запись
                job(num)
            end
        end 
    end

    # запись числа
    def self.job(number)
        # открываем файл с результатами
        source_file = File.open("data/1.txt", 'r') 
        # создаем временный файл
        tempfile = Tempfile.new('foo')
        # переменная для обнаружения первого совпадения с условием
        found = false
        # читаем каждый лайн файла с результатами
        source_file.each do |line|
            # если совпадений не было и входное число меньше числа из результирующего файла 
            if !found && number <= line.to_i
                # записываем число во временный файл
                tempfile.puts(number)
                # сообщаем что совпадение обнаружено, болше не надо искать совпадений с условием
                found = true
            end
            # записываем лайн из результирующего файла во временный файл
            tempfile.puts(line)
        end
        # если совпадений не найдено, то записываем число в конец временного файла
        tempfile << number if !found
        # закрываем временный файл
        tempfile.close
        # заменяем содержимое файла с результатами на содержимое временного файла
        FileUtils.mv(tempfile.path, source_file)
        # закрываем файл с результатом
        source_file.close
    end
end

# Начало работы программы
Example.process('file1.txt', 'file2.txt')
