﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ИспользоватьПодчиненныеБизнесПроцессы = ПолучитьФункциональнуюОпцию("ИспользоватьПодчиненныеБизнесПроцессы");	
	
	Если ИспользоватьПодчиненныеБизнесПроцессы Тогда
		Элементы.Список.Видимость = Ложь;
		Элементы.КоманднаяПанельСписка.Видимость = Ложь;
		Элементы.ПоказыватьВыполненные.Видимость = Ложь;
		Элементы.ДеревоЗадач.Видимость = Истина;
	Иначе	
		Элементы.Список.Видимость = Истина;
		Элементы.КоманднаяПанельСписка.Видимость = Истина;
		Элементы.ПоказыватьВыполненные.Видимость = Истина;
		Элементы.ДеревоЗадач.Видимость = Ложь;
	КонецЕсли;	
	
	Список.Параметры.Элементы[0].Значение = Параметры.ЗначениеОтбора;
	Список.Параметры.Элементы[0].Использование = Истина;
	Заголовок = НСтр("ru = 'Задачи по предмету'");
	ИспользоватьДатуИВремяВСрокахЗадач = ПолучитьФункциональнуюОпцию("ИспользоватьДатуИВремяВСрокахЗадач");
	Элементы.СрокИсполнения.Формат = ?(ИспользоватьДатуИВремяВСрокахЗадач, "ДЛФ=DT", "ДЛФ=D");
	БизнесПроцессыИЗадачиСервер.УстановитьОформлениеЗадач(Список);
	УстановитьОтбор(Новый Структура("ПоказыватьВыполненные", ПоказыватьВыполненные));
	
	Если ИспользоватьПодчиненныеБизнесПроцессы Тогда 
		ЗаполнитьДеревоЗадач();
	КонецЕсли;
	
	// Установка отбора динамического списка.
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список, "ПометкаУдаления", Ложь, ВидСравненияКомпоновкиДанных.Равно, , ,
		РежимОтображенияЭлементаНастройкиКомпоновкиДанных.БыстрыйДоступ);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "Запись_ЗадачаИсполнителя" Тогда
		ОбновитьСписокЗадач();
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	УстановитьОтбор(Настройки);
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура ПоказыватьВыполненныеПриИзменении(Элемент)
	УстановитьОтбор(Новый Структура("ПоказыватьВыполненные", ПоказыватьВыполненные));
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ Список

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	БизнесПроцессыИЗадачиКлиент.СписокЗадачВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка);
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ ДеревоЗадач

&НаКлиенте
Процедура ДеревоЗадачВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОткрытьТекущуюСтрокуДереваЗадач();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура Обновить(Команда)
	
	ОбновитьСписокЗадач();
	Для каждого Строка ИЗ ДеревоЗадач.ПолучитьЭлементы() Цикл
		Элементы.ДеревоЗадач.Развернуть(Строка.ПолучитьИдентификатор(), Истина);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура Изменить(Команда)
	
	ОткрытьТекущуюСтрокуДереваЗадач();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Процедура УстановитьОтбор(ПараметрыОтбора)
	
	Если НЕ ПараметрыОтбора["ПоказыватьВыполненные"] Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список, "Выполнена", Ложь);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДеревоЗадач()
	
	Дерево = РеквизитФормыВЗначение("ДеревоЗадач");
	Дерево.Строки.Очистить();
	
	ДобавитьЗадачиПоПредмету(Дерево, Параметры.ЗначениеОтбора);
	
	ЗначениеВРеквизитФормы(Дерево, "ДеревоЗадач");
	
КонецПроцедуры	

&НаСервере
Процедура ОбновитьСписокЗадач()
	
	ИспользоватьПодчиненныеБизнесПроцессы = ПолучитьФункциональнуюОпцию("ИспользоватьПодчиненныеБизнесПроцессы");
	Если ИспользоватьПодчиненныеБизнесПроцессы Тогда 
		ЗаполнитьДеревоЗадач();
	Иначе
		БизнесПроцессыИЗадачиСервер.УстановитьОформлениеЗадач(Список);
		Элементы.Список.Обновить();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьЗадачиПоПредмету(Дерево, Предмет)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	Задачи.Ссылка,
		|	Задачи.Наименование,
		|	Задачи.Исполнитель,
		|	Задачи.РольИсполнителя,
		|	Задачи.СрокИсполнения,
		|	Задачи.Выполнена,
		|	ВЫБОР
		|		КОГДА Задачи.Важность = ЗНАЧЕНИЕ(Перечисление.ВариантыВажностиЗадачи.Низкая)
		|			ТОГДА 0
		|		КОГДА Задачи.Важность = ЗНАЧЕНИЕ(Перечисление.ВариантыВажностиЗадачи.Высокая)
		|			ТОГДА 2
		|		ИНАЧЕ 1
		|	КОНЕЦ КАК Важность,
		|	ВЫБОР
		|		КОГДА Задачи.СостояниеБизнесПроцесса = ЗНАЧЕНИЕ(Перечисление.СостоянияБизнесПроцессов.Остановлен)
		|			ТОГДА Истина
		|		ИНАЧЕ Ложь
		|	КОНЕЦ КАК Остановлен
		|ИЗ
		|	Задача.ЗадачаИсполнителя КАК Задачи
		|ГДЕ
		|   Задачи.Предмет = &Предмет
		|   И Задачи.ПометкаУдаления = Ложь";
		
	Запрос.УстановитьПараметр("Предмет", Предмет);

	Результат = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = Результат.Выбрать();

	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		
		Ветвь = Дерево.Строки.Найти(ВыборкаДетальныеЗаписи.Ссылка, "Ссылка", Истина);
		Если Ветвь = Неопределено Тогда
			Строка = Дерево.Строки.Добавить();
			
			Строка.Наименование = ВыборкаДетальныеЗаписи.Наименование;
			Строка.Важность = ВыборкаДетальныеЗаписи.Важность;
			Строка.Тип = 1;
			Строка.Остановлен = ВыборкаДетальныеЗаписи.Остановлен;
			Строка.Ссылка = ВыборкаДетальныеЗаписи.Ссылка;
			Строка.СрокИсполнения = ВыборкаДетальныеЗаписи.СрокИсполнения;
			Строка.Выполнена = ВыборкаДетальныеЗаписи.Выполнена;
			Если ВыборкаДетальныеЗаписи.СрокИсполнения <> "00010101" 
				И ВыборкаДетальныеЗаписи.СрокИсполнения < ТекущаяДатаСеанса() Тогда
				Строка.Просрочена = Истина;
			КонецЕсли;				
			Если ВыборкаДетальныеЗаписи.Исполнитель.Пустая() Тогда
				Строка.Исполнитель = ВыборкаДетальныеЗаписи.РольИсполнителя;
			Иначе	
				Строка.Исполнитель = ВыборкаДетальныеЗаписи.Исполнитель;
			КонецЕсли;	
			
			ДобавитьПодчиненныеБизнесПроцессы(Дерево, ВыборкаДетальныеЗаписи.Ссылка);
		КонецЕсли;	
		
	КонецЦикла;
	
КонецПроцедуры	

&НаСервере
Процедура ДобавитьПодчиненныеБизнесПроцессы(Дерево, ЗадачаСсылка)
	
	Ветвь = Дерево.Строки.Найти(ЗадачаСсылка, "Ссылка", Истина);
	
	Для каждого МетаданныеБизнесПроцесса Из Метаданные.БизнесПроцессы Цикл
		
		// У бизнес-процесса может и не быть главной задачи
		РеквизитГлавнаяЗадача = МетаданныеБизнесПроцесса.Реквизиты.Найти("ГлавнаяЗадача");
		Если РеквизитГлавнаяЗадача = Неопределено Тогда
			Продолжить;
		КонецЕсли;	
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
			"ВЫБРАТЬ РАЗРЕШЕННЫЕ
			|	БизнесПроцессы.Ссылка,
			|	БизнесПроцессы.Наименование,
			|	БизнесПроцессы.Завершен,
			|	ВЫБОР
			|		КОГДА БизнесПроцессы.Важность = ЗНАЧЕНИЕ(Перечисление.ВариантыВажностиЗадачи.Низкая)
			|			ТОГДА 0
			|		КОГДА БизнесПроцессы.Важность = ЗНАЧЕНИЕ(Перечисление.ВариантыВажностиЗадачи.Высокая)
			|			ТОГДА 2
			|		ИНАЧЕ 1
			|	КОНЕЦ КАК Важность,
			|	ВЫБОР
			|		КОГДА БизнесПроцессы.Состояние = ЗНАЧЕНИЕ(Перечисление.СостоянияБизнесПроцессов.Остановлен)
			|			ТОГДА Истина
			|		ИНАЧЕ Ложь
			|	КОНЕЦ КАК Остановлен
			|ИЗ
			|	%БизнесПроцесс% КАК БизнесПроцессы
			|ГДЕ
			|   БизнесПроцессы.ГлавнаяЗадача = &ГлавнаяЗадача
			|   И БизнесПроцессы.ПометкаУдаления = Ложь";
			
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "%БизнесПроцесс%", МетаданныеБизнесПроцесса.ПолноеИмя());
		Запрос.УстановитьПараметр("ГлавнаяЗадача", ЗадачаСсылка);

		Результат = Запрос.Выполнить();
		
		ВыборкаДетальныеЗаписи = Результат.Выбрать();

		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			
			ДобавитьЗадачиПодчиненногоБизнесПроцесса(Дерево, ВыборкаДетальныеЗаписи.Ссылка, ЗадачаСсылка);
			
		КонецЦикла;
		
	КонецЦикла;	

КонецПроцедуры

&НаСервере
Процедура ДобавитьЗадачиПодчиненногоБизнесПроцесса(Дерево, БизнесПроцессСсылка, ЗадачаСсылка)
	
	Ветвь = Дерево.Строки.Найти(ЗадачаСсылка, "Ссылка", Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	Задачи.Ссылка,
		|	Задачи.Наименование,
		|	Задачи.Исполнитель,
		|	Задачи.РольИсполнителя,
		|	Задачи.СрокИсполнения,
		|	Задачи.Выполнена,
		|	ВЫБОР
		|		КОГДА Задачи.Важность = ЗНАЧЕНИЕ(Перечисление.ВариантыВажностиЗадачи.Низкая)
		|			ТОГДА 0
		|		КОГДА Задачи.Важность = ЗНАЧЕНИЕ(Перечисление.ВариантыВажностиЗадачи.Высокая)
		|			ТОГДА 2
		|		ИНАЧЕ 1
		|	КОНЕЦ КАК Важность,
		|	ВЫБОР
		|		КОГДА Задачи.СостояниеБизнесПроцесса = ЗНАЧЕНИЕ(Перечисление.СостоянияБизнесПроцессов.Остановлен)
		|			ТОГДА Истина
		|		ИНАЧЕ Ложь
		|	КОНЕЦ КАК Остановлен
		|ИЗ
		|	Задача.ЗадачаИсполнителя КАК Задачи
		|ГДЕ
		|   Задачи.БизнесПроцесс = &БизнесПроцесс
		|   И Задачи.ПометкаУдаления = Ложь";
		
	Запрос.УстановитьПараметр("БизнесПроцесс", БизнесПроцессСсылка);

	Результат = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = Результат.Выбрать();

	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		
		НайденнаяВетвь = Дерево.Строки.Найти(ВыборкаДетальныеЗаписи.Ссылка, "Ссылка", Истина);
		Если НайденнаяВетвь <> Неопределено Тогда
			Дерево.Строки.Удалить(НайденнаяВетвь);
		КонецЕсли;	
			
		Строка = Неопределено;
		Если Ветвь = Неопределено Тогда
			Строка = Дерево.Строки.Добавить();
		Иначе	
			Строка = Ветвь.Строки.Добавить();
		КонецЕсли;
		
		Строка.Наименование = ВыборкаДетальныеЗаписи.Наименование;
		Строка.Важность = ВыборкаДетальныеЗаписи.Важность;
		Строка.Тип = 1;
		Строка.Остановлен = ВыборкаДетальныеЗаписи.Остановлен;
		Строка.Ссылка = ВыборкаДетальныеЗаписи.Ссылка;
		Строка.СрокИсполнения = ВыборкаДетальныеЗаписи.СрокИсполнения;
		Строка.Выполнена = ВыборкаДетальныеЗаписи.Выполнена;
		Если ВыборкаДетальныеЗаписи.СрокИсполнения <> '00010101000000' 
			И ВыборкаДетальныеЗаписи.СрокИсполнения < ТекущаяДатаСеанса() Тогда
			Строка.Просрочена = Истина;
		КонецЕсли;				
		Если ВыборкаДетальныеЗаписи.Исполнитель.Пустая() Тогда
			Строка.Исполнитель = ВыборкаДетальныеЗаписи.РольИсполнителя;
		Иначе	
			Строка.Исполнитель = ВыборкаДетальныеЗаписи.Исполнитель;
		КонецЕсли;	
		
		ДобавитьПодчиненныеБизнесПроцессы(Дерево, ВыборкаДетальныеЗаписи.Ссылка);
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьТекущуюСтрокуДереваЗадач()
	
	Если Элементы.ДеревоЗадач.ТекущиеДанные = Неопределено Тогда
		Возврат;	
	КонецЕсли;	
		
	СтандартнаяОбработка = Истина;
	Если ТипЗнч(Элементы.ДеревоЗадач.ТекущиеДанные.Ссылка) = Тип("ЗадачаСсылка.ЗадачаИсполнителя") Тогда
		СтандартнаяОбработка = Не БизнесПроцессыИЗадачиКлиент.ОткрытьФормуВыполненияЗадачи(Элементы.ДеревоЗадач.ТекущиеДанные.Ссылка);
	КонецЕсли;	
	
	Если СтандартнаяОбработка Тогда 
		ОткрытьЗначение(Элементы.ДеревоЗадач.ТекущиеДанные.Ссылка);
	КонецЕсли;	

КонецПроцедуры

