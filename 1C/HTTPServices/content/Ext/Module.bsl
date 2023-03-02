﻿Функция IndexGET(Запрос)
	
	ОтносительныйURL =  Запрос.ОтносительныйURL;
	ПутьВКаталоге = СтрЗаменить(ОтносительныйURL,"/","\");
	Если  ПутьВКаталоге = "" Тогда
		ПутьВКаталоге = "/index.html";
	КонецЕсли;
	
	ИмяФайла = ПолучитьПутьКСборке() + ПутьВКаталоге;  
	
	Файлик = Новый Файл(ИмяФайла);   
	Если Файлик.Существует() Тогда	
		ЗаписьЖурналаРегистрации("Файл есть"); 
		ТипКонтента = ПолучитьТипКонтента(Файлик.Расширение);
	Иначе
		ВызватьИсключение ИмяФайла;
	КонецЕсли;
	
	Возврат ПередатьФайл(ИмяФайла, ТипКонтента);
	
КонецФункции  

Функция ПолучитьТипКонтента(Расширение)
	
	Если Расширение = ".js" Тогда
		Возврат "text/javascript";
	ИначеЕсли Расширение = ".css" Тогда
		Возврат "text/css"; 
	ИначеЕсли Расширение = ".svg" Тогда 
		Возврат "image/svg+xml";
	ИначеЕсли Расширение = ".png" Тогда 
		Возврат "image/png"; 
	КонецЕсли;
	
КонецФункции  

Функция ПолучитьПутьКСборке() Экспорт
	
	Возврат Константы.ПутьКСборке.Получить();
	
КонецФункции

Функция ПередатьФайл(ИмяФайла, ContentType)  Экспорт
	
	
	Ответ = Новый HTTPСервисОтвет(200);  
	
	ДвоичныеДанныеФайла = Новый ДвоичныеДанные(ИмяФайла);
	
	Ответ = Новый HTTPСервисОтвет(200);  
	Поток =  Ответ.ПолучитьТелоКакПоток();
	Ответ.Заголовки.Вставить("Content-Type", ContentType);
	ЧтениеДанных = Новый ЧтениеДанных(ДвоичныеДанныеФайла);
	// читаем до конца файла / целиком
	РезультатЧтения = ЧтениеДанных.Прочитать();
	Ответ.Заголовки.Вставить("Content-Length", РезультатЧтения.Размер);
	Запись = Новый ЗаписьДанных(Поток);
	// Вариант синтаксиса: Запись результата чтения данных
	Запись.Записать(РезультатЧтения);
	ЧтениеДанных.Закрыть();
	Запись.Закрыть();
	Возврат Ответ;
	
КонецФункции

Функция apiGET(Запрос)
	
	Ответ = Новый HTTPСервисОтвет(200); 
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	Задачи.Код КАК Код,
	               |	Задачи.Наименование КАК Наименование,
	               |	Задачи.Ссылка КАК Ссылка
				   |ИЗ
	               |	Справочник.Задачи КАК Задачи"; 
	
	
	ДанныеОтвета = Новый Массив;
	Выборка = Запрос.Выполнить().Выбрать(); 
	Пока Выборка.Следующий() Цикл
		
		СтруктураОбъекта = Новый Структура("id, name, code");
		СтруктураОбъекта.id = Строка(Выборка.Ссылка.УникальныйИдентификатор());
		СтруктураОбъекта.name = Строка(Выборка.Наименование);  
		СтруктураОбъекта.code = Строка(Выборка.Код);  
		
		ДанныеОтвета.Добавить(СтруктураОбъекта);
		
	КонецЦикла;
	
	
	Ответ.Заголовки.Вставить("Content-Type","text/text; charset=UTF-8");
	Ответ.Заголовки.Вставить("Content-Type","application/json");
	
	ЗаписьJSON = Новый ЗаписьJSON;
	ЗаписьJSON.УстановитьСтроку();
	ЗаписатьJSON(ЗаписьJSON, ДанныеОтвета); 
	ДанныеJSON = ЗаписьJSON.Закрыть();
	Ответ.УстановитьТелоИзСтроки(ДанныеJSON);
	
	
	Возврат Ответ;
	
	
КонецФункции

