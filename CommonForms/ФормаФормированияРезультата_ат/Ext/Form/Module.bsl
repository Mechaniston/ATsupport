﻿
&НаКлиенте
Перем КоординатыЗаменяемогоСлова;

&НаКлиенте
Перем СоответствиеКомандЗаменыСловам;

#Область ОбработчикиСобытийФормы
	
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Заявка = Параметры.Заявка;
	ЗаполнитьДерево(Заявка);
	
	РаботаСHTML_Сервер_ат.СоздатьПанелиРаботыСHTML(ЭтаФорма, Элементы.КомманднаяПанельКнопокРедактированияHTML_Предпросмотр,
		"ОбработчикКомандРаботыСHTML_Предпросмотр", Истина, Элементы.ПредпросмотрКонтекстноеМеню);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ДеревоРезультатовИспользоватьПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ДеревоРезультатов.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ТекущиеДанные.Ссылка)
	   И НЕ ТекущиеДанные.ЭтоРучнойТекст Тогда
		ТекущиеДанные.Использовать = Ложь;
	КонецЕсли;
	
	Если НомерСтроки = Элементы.ДеревоРезультатов.ТекущаяСтрока Тогда
		СохранитьИзменениеТекста();
	КонецЕсли;
	
	СформироватьРезультат();
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоРезультатовПриАктивизацииСтроки(Элемент)
	
	СохранитьИзменениеТекста();
	ВывестиНаПредпросмотр();
	УстановитьДоступностьЭлементовУправления();
	СформироватьРезультат();
	
КонецПроцедуры

&НаСервере
Процедура ВставитьРучнойТекстНаСервере(Ссылка = Неопределено)
	
	Дерево = РеквизитФормыВЗначение("ДеревоРезультатов");
	
	Если ЗначениеЗаполнено(Ссылка) Тогда
		
		ТекущаяСтрокаДерева = Дерево.Строки.Найти(Ссылка);
		
		Если ТекущаяСтрокаДерева = Неопределено Тогда
			СтрокиРодителя = Дерево.Строки;
		Иначе
			СтрокиРодителя = ТекущаяСтрокаДерева.Строки
		КонецЕсли;
		
	Иначе
		СтрокиРодителя = Дерево.Строки;
	КонецЕсли;
	
	НоваяСтрока = СтрокиРодителя.Добавить();
	НоваяСтрока.Описание = "Ручной текст";
	НоваяСтрока.ЭтоРучнойТекст = Истина;
	НоваяСтрока.РучнойТекст = РаботаСHTML_КлиентСервер_ат.ПреобразоватьОбычныйТекстВHTML("");
	
	ЗначениеВРеквизитФормы(Дерево, "ДеревоРезультатов");
	
КонецПроцедуры

&НаКлиенте
Процедура ВставитьРучнойТекст(Команда)
	
	ТекущиеДанные = Элементы.ДеревоРезультатов.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		ВставитьРучнойТекстНаСервере();
	Иначе
		ВставитьРучнойТекстНаСервере(ТекущиеДанные.Ссылка);
	КонецЕсли;
	
	РазвернутьВсе();
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппаСтраницыПредпросмотраПриСменеСтраницы(Элемент, ТекущаяСтраница)
	
	Если НЕ Элементы.ГруппаСтраницыПредпросмотра.ТекущаяСтраница = Элементы.ГруппаПредпросмотрТекстHTML Тогда
		
		РаботаСHTML_Клиент_ат.УстановитьДоступностьПанелейРедактирования(Элементы.КомманднаяПанельКнопокРедактированияHTML_Предпросмотр,
																			Элемент, Ложь);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоРезультатовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.ДеревоРезультатов.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ОткрытьЗначение(ТекущиеДанные.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоРезультатовОкончаниеПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка)
	
	СформироватьРезультат();
	РазвернутьВсе();
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоРезультатовПриСменеТекущегоРодителя(Элемент)
	
	СформироватьРезультат();
	РазвернутьВсе();
	
КонецПроцедуры

&НаСервере
Процедура ОКНаСервере(ТекстРезультата)
		
	НаборЗаписей = РегистрыСведений.СтруктураРезультатаЗаявки_ат.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Заявка.Установить(Заявка);
	НаборЗаписей.Прочитать();
	
	НаборЗаписей.Очистить();
	
	Дерево = РеквизитФормыВЗначение("ДеревоРезультатов");
	Счетчик = 1;
	
	ЗаписатьВРегистрРекурсивно(Дерево.Строки, НаборЗаписей, Счетчик);
	
	НаборЗаписей.Записать();
	
	НаборЗаписей = РегистрыСведений.СвойстваЗаявок_ат.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Ссылка.Установить(Заявка);
	НаборЗаписей.Прочитать();
	
	Если НаборЗаписей.Количество() > 0 Тогда
		
		Запись = НаборЗаписей[0];
		Запись.РезультатВыполнения = ТекстРезультата;
		
		НаборЗаписей.Записать();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьВРегистрРекурсивно(СтрокиДерева, НаборЗаписей, Счетчик, Знач СсылкаНаКод = 0)
	
	Для Каждого СтрокаДерева Из СтрокиДерева Цикл
		
		Если СтрокаДерева.ЭтоРучнойТекст
		 ИЛИ ЗначениеЗаполнено(СтрокаДерева.Ссылка) Тогда
			
			Запись = НаборЗаписей.Добавить();			
			Запись.Заявка = Заявка;
			Запись.Задание = СтрокаДерева.Ссылка;
			ЗаполнитьЗначенияСвойств(Запись, СтрокаДерева);
			Код = ?(СтрокаДерева.Код > 0, СтрокаДерева.Код, Счетчик);
			Запись.СсылкаНаКод = СсылкаНаКод;
			Запись.Код = Код;
			Запись.Порядок = Счетчик;
			Счетчик = Счетчик + 1;
			
		КонецЕсли;
		
		ЗаписатьВРегистрРекурсивно(СтрокаДерева.Строки, НаборЗаписей, Счетчик, Код);
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ОК(Команда)
	
	ТекстРезультата = Элементы.Результат.Документ.Body.InnerHTML;
			
	ОКНаСервере(ТекстРезультата);
	Оповестить("ЗаписьРезультата", ТекстРезультата, ВладелецФормы);
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура НаУровеньНиже(Команда)
		
	ТекущиеДанные = Элементы.ДеревоРезультатов.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	НомерТекущейСтроки = Элементы.ДеревоРезультатов.ТекущаяСтрока;
	Если НомерТекущейСтроки > 0 Тогда
		
		ТекущаяСтрока = ДеревоРезультатов.НайтиПоИдентификатору(Элементы.ДеревоРезультатов.ТекущаяСтрока);
		Родитель = ТекущаяСтрока.ПолучитьРодителя();
		
		ПредыдущаяСтрока = Неопределено;
		
		Если Родитель = Неопределено Тогда
			ЭлементыРодителя = ДеревоРезультатов.ПолучитьЭлементы();
		Иначе
			ЭлементыРодителя = Родитель.ПолучитьЭлементы();
		КонецЕсли;
		
		Для Каждого СтрокаДерева Из Родитель.ПолучитьЭлементы() Цикл
			
			Если СтрокаДерева = ТекущаяСтрока Тогда
				
				Если НЕ ПредыдущаяСтрока = Неопределено Тогда
					
					ПереместитьСтрокуДереваРекурсивно(ПредыдущаяСтрока, ТекущиеДанные);
					Родитель.ПолучитьЭлементы().Удалить(ТекущаяСтрока);
					
				КонецЕсли;
				
			КонецЕсли;
			
			ПредыдущаяСтрока = СтрокаДерева;
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПереместитьСтрокуДереваРекурсивно(Родитель, Строка)
	
	ЭлементыРодителя = Родитель.ПолучитьЭлементы();
	НоваяСтрока = ЭлементыРодителя.Добавить();
	ЗаполнитьЗначенияСвойств(НоваяСтрока, Строка);
	
	Для Каждого ПодчиненнаяСтрока Из Строка.ПолучитьЭлементы() Цикл
	
		ПереместитьСтрокуДереваРекурсивно(НоваяСтрока, ПодчиненнаяСтрока);
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти 

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура СохранитьИзменениеТекста()
	
	Если ЗначениеЗаполнено(НомерСтроки) Тогда
		
		Строка = ДеревоРезультатов.НайтиПоИдентификатору(НомерСтроки);
		Если НЕ Строка = Неопределено
		   И Строка.ЭтоРучнойТекст Тогда
			
			Строка.РучнойТекст = Элементы.Предпросмотр.Документ.Body.InnerHTML;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВывестиНаПредпросмотр()
	
	ТекущиеДанные = Элементы.ДеревоРезультатов.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	НомерСтроки = Элементы.ДеревоРезультатов.ТекущаяСтрока;
	Если ТекущиеДанные.ЭтоРучнойТекст Тогда
		
		Элементы.ГруппаСтраницыПредпросмотра.ТекущаяСтраница = Элементы.ГруппаПредпросмотрТекстHTML;
		Элементы.Предпросмотр.Документ.Body.InnerHTML = ТекущиеДанные.РучнойТекст;
		
	Иначе
		
		Элементы.ГруппаСтраницыПредпросмотра.ТекущаяСтраница = Элементы.ГруппаПродпросмотрОбычныйТекст;
		
		Если ЗначениеЗаполнено(ТекущиеДанные.Ссылка) Тогда
			
			Свойства = Планирование_Сервер_ат.ПолучитьСвойстваЗадания(ТекущиеДанные.Ссылка);
			ПредпросмотрОбычныйТекст = Свойства.РезультатВыполнения;
			
		Иначе
			
			ПредпросмотрОбычныйТекст = "";
			
		КонецЕсли;
		
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура СформироватьРезультат()
	
	ЭлементыДерева = ДеревоРезультатов.ПолучитьЭлементы();
	
	ТекстРезультата = "";
	
	СформироватьРезультатРекурсивно(ЭлементыДерева, ТекстРезультата);
	
	Элементы.Результат.Документ.Body.InnerHTML = ТекстРезультата;
	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьРезультатРекурсивно(Строки, ТекстРезультата)
	
	Для Каждого Строка Из Строки Цикл
		
		Если Строка.Использовать Тогда
		
			Если Строка.ЭтоРучнойТекст Тогда
				
				ТекстРезультата = ТекстРезультата + ?(ПустаяСтрока(ТекстРезультата), "", "<br>") + Строка.РучнойТекст;
				
			Иначе
				
				Если ЗначениеЗаполнено(Строка.Ссылка) Тогда
					
					Свойства = Планирование_Сервер_ат.ПолучитьСвойстваЗадания(Строка.Ссылка);
					ТекстРезультата = ТекстРезультата + ?(ПустаяСтрока(ТекстРезультата), "", "<br>")
									+ РаботаСHTML_КлиентСервер_ат.ПреобразоватьОбычныйТекстВHTML(Свойства.РезультатВыполнения);
					
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЕсли;
		
		СформироватьРезультатРекурсивно(Строка.ПолучитьЭлементы(), ТекстРезультата);
				
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДоступностьЭлементовУправления()
	
	ТекущиеДанные = Элементы.ДеревоРезультатов.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
		
	Если ТекущиеДанные.ЭтоРучнойТекст Тогда
		
		Элементы.КомманднаяПанельКнопокРедактированияHTML_Предпросмотр.Доступность = Истина;
		Элементы.ПредпросмотрКонтекстноеМеню.Доступность = Истина;
		
	Иначе
		
		Элементы.КомманднаяПанельКнопокРедактированияHTML_Предпросмотр.Доступность = Ложь;
		Элементы.ПредпросмотрКонтекстноеМеню.Доступность = Ложь;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДерево(Заявка)
	
	Дерево = РеквизитФормыВЗначение("ДеревоРезультатов");
	Дерево.Строки.Очистить();
	
	СтрокаЗаявки = Дерево.Строки.Добавить();
	СтрокаЗаявки.Описание = "Заявка: " + Заявка.Тезис;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ЕСТЬNULL(СтруктураРезультатаЗаявки_ат.Код, СвязиОбъектов.Код) КАК Код,
	|	ЕСТЬNULL(СтруктураРезультатаЗаявки_ат.Задание, СвязиОбъектов.Объект) КАК Объект,
	|	ЕСТЬNULL(СтруктураРезультатаЗаявки_ат.СсылкаНаКод, СвязиОбъектов.СсылкаНаКод) КАК СсылкаНаКод,
	|	ЕСТЬNULL(СтруктураРезультатаЗаявки_ат.Использовать, ИСТИНА) КАК Использовать,
	|	ЕСТЬNULL(СтруктураРезультатаЗаявки_ат.ЭтоРучнойТекст, ЛОЖЬ) КАК ЭтоРучнойТекст,
	|	ЕСТЬNULL(СтруктураРезультатаЗаявки_ат.РучнойТекст, """") КАК РучнойТекст,
	|	ЕСТЬNULL(СтруктураРезультатаЗаявки_ат.Порядок, 999999) КАК Порядок,
	|	NULL КАК Описание
	|ИЗ
	|	РегистрСведений.СвязиОбъектов_ат КАК СвязиОбъектов
	|		ПОЛНОЕ СОЕДИНЕНИЕ РегистрСведений.СтруктураРезультатаЗаявки_ат КАК СтруктураРезультатаЗаявки_ат
	|		ПО СвязиОбъектов.Объект = СтруктураРезультатаЗаявки_ат.Задание
	|ГДЕ
	|	СвязиОбъектов.Предок = &Объект
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	СтруктураРезультатаЗаявки_ат.Код,
	|	СтруктураРезультатаЗаявки_ат.Задание,
	|	СтруктураРезультатаЗаявки_ат.СсылкаНаКод,
	|	СтруктураРезультатаЗаявки_ат.Использовать,
	|	СтруктураРезультатаЗаявки_ат.ЭтоРучнойТекст,
	|	СтруктураРезультатаЗаявки_ат.РучнойТекст,
	|	СтруктураРезультатаЗаявки_ат.Порядок,
	|	СтруктураРезультатаЗаявки_ат.Описание
	|ИЗ
	|	РегистрСведений.СтруктураРезультатаЗаявки_ат КАК СтруктураРезультатаЗаявки_ат
	|ГДЕ
	|	СтруктураРезультатаЗаявки_ат.Заявка = &Объект
	|	И СтруктураРезультатаЗаявки_ат.ЭтоРучнойТекст
	|
	|УПОРЯДОЧИТЬ ПО
	|	Порядок";
	Запрос.УстановитьПараметр("Объект", Заявка);
	
	ТаблицаСвязей = Запрос.Выполнить().Выгрузить();
	
	Если ТаблицаСвязей.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ТаблицаСвязей.Индексы.Добавить("Код");
	ТаблицаСвязей.Колонки.Добавить("СсылкаНаСтроку");
	
	Для Каждого СтрокаТаблицыСвязей Из ТаблицаСвязей Цикл
		
		Если НЕ Дерево.Строки.Найти(СтрокаТаблицыСвязей.Код, "Код", Истина) = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		СтрокаРодителя = Неопределено;
		
		Если СтрокаТаблицыСвязей.СсылкаНаКод > 0 Тогда
			
			ПоискРодителя = ТаблицаСвязей.Найти(СтрокаТаблицыСвязей.СсылкаНаКод, "Код");
			
			Если ПоискРодителя <> Неопределено Тогда
				
				СтрокаРодителя = ПоискРодителя.СсылкаНаСтроку;
				
			КонецЕсли;
			
		КонецЕсли;
		
		Если СтрокаРодителя = Неопределено Тогда
			
			СтрокаРодителя = СтрокаЗаявки.Строки;
			
		КонецЕсли;
				
		НоваяСтрока = СтрокаРодителя.Добавить();
		НоваяСтрока.Ссылка = СтрокаТаблицыСвязей.Объект;
		Если СтрокаТаблицыСвязей.ЭтоРучнойТекст Тогда
			
			НоваяСтрока.Описание = "Ручной текст";
			НоваяСтрока.ЭтоРучнойТекст = Истина;
			НоваяСтрока.РучнойТекст = СтрокаТаблицыСвязей.РучнойТекст;
			
		Иначе
		
			НоваяСтрока.Описание = "Задание: " + СтрокаТаблицыСвязей.Объект.Тезис;
			
		КонецЕсли;
		
		НоваяСтрока.Использовать = СтрокаТаблицыСвязей.Использовать;
		
		НоваяСтрока.Код = СтрокаТаблицыСвязей.Код;
		СтрокаТаблицыСвязей.СсылкаНаСтроку = НоваяСтрока.Строки;
		
	КонецЦикла;
	
	ЗначениеВРеквизитФормы(Дерево, "ДеревоРезультатов");
	
КонецПроцедуры

&НаКлиенте
Процедура РазвернутьВсе()
	
   тЭлементы = ДеревоРезультатов.ПолучитьЭлементы();
   Для Каждого тСтр Из тЭлементы Цикл
      Элементы.ДеревоРезультатов.Развернуть(тСтр.ПолучитьИдентификатор(), Истина);
  КонецЦикла;
  
КонецПроцедуры

#КонецОбласти 

#Область HTMLПредпросмотр

&НаКлиенте
Процедура ОбработчикКомандРаботыСHTML_Предпросмотр(Команда, ВыбранноеЗначение)
	
	РаботаСHTML_Клиент_ат.ОбработчикКомандРаботыСHTML(ЭтаФорма, Команда, ВыбранноеЗначение,
		Элементы.Предпросмотр, Элементы.КомманднаяПанельКнопокРедактированияHTML_Предпросмотр,
		КоординатыЗаменяемогоСлова, СоответствиеКомандЗаменыСловам);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредпросмотрДокументСформирован(Элемент)
	
	//ДобавитьОбработчик Элемент.Документ.Body.OnContextMenu, ОбработчикСобытийПоляHTML_Предпросмотр;
	//ДобавитьОбработчик Элемент.Документ.Body.OnPaste, ОбработчикСобытийПоляHTML_Предпросмотр;
	
	РаботаСHTML_Клиент_ат.УстановитьДоступностьПанелейРедактирования(Элементы.КомманднаяПанельКнопокРедактированияHTML_Предпросмотр,
		Элемент, Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработчикСобытийПоляHTML_Предпросмотр(Событие) Экспорт
	
	Если Событие.type = "contextmenu" Тогда
		
		ПолеМожноРедактировать = РаботаСHTML_Клиент_ат.HTMLПолеМожноРедактировать(Элементы.Предпросмотр);
		
		Для Каждого ЭлементКонтекстногоМеню Из Элементы.Предпросмотр.КонтекстноеМеню.ПодчиненныеЭлементы Цикл
			
			Если НЕ ЭлементКонтекстногоМеню.Имя = "Предпросмотр_КонтекстноеМеню_ВключитьВозможностьРедактирования"
			   И НЕ ЭлементКонтекстногоМеню.Имя = "Предпросмотр_КонтекстноеМеню_ПроверитьОрфографию" Тогда
				ЭлементКонтекстногоМеню.Доступность = ПолеМожноРедактировать;
			КонецЕсли;
			
		КонецЦикла;
		
		Если ПолеМожноРедактировать Тогда	

			Если Событие.srcElement.id = "red_marker" Тогда
				
				РаботаСHTML_Клиент_ат.ОбработатьВызовКонтекстногоМеню(Событие, КоординатыЗаменяемогоСлова, СоответствиеКомандЗаменыСловам);	
				
				ИзменитьКонтестноеМенюЗаменыСловПоляHTML_Предпросмотр(СоответствиеКомандЗаменыСловам);
				
			Иначе
				
				ИзменитьКонтестноеМенюЗаменыСловПоляHTML_Предпросмотр(Неопределено, Истина);
				
			КонецЕсли;
			
		Иначе
			
			ИзменитьКонтестноеМенюЗаменыСловПоляHTML_Предпросмотр(Неопределено, Истина);
			
		КонецЕсли;
		
	ИначеЕсли Событие.type = "paste" Тогда
		
		ИдентификаторыКартинок.ЗагрузитьЗначения(РаботаСHTML_Клиент_ат.ПолучитьИдентификаторыКартинок(Элементы.Предпросмотр.Документ));
		ПодключитьОбработчикОжидания("УдалитьКартинкиВставленныеКопированием_Предпросмотр", 0.2, Истина);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьКартинкиВставленныеКопированием_Предпросмотр() Экспорт
	
	РаботаСHTML_Клиент_ат.УдалитьКартинкиВставленныеКопированием(Элементы.Содержание.Документ,
																	ИдентификаторыКартинок.ВыгрузитьЗначения());
	
КонецПроцедуры

&НаСервере
Процедура ИзменитьКонтестноеМенюЗаменыСловПоляHTML_Предпросмотр(СоответствиеКомандЗаменыСловам, ТолькоОчистить = Ложь)
	
	РаботаСHTML_Сервер_ат.ИзменитьКонтестноеМенюЗаменыСловПоляHTML(ЭтаФорма,
		Элементы.Содержание.КонтекстноеМеню, СоответствиеКомандЗаменыСловам, ТолькоОчистить, "ОбработчикКомандРаботыСHTML");
	
КонецПроцедуры

&НаКлиенте
Процедура ПредпросмотрПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	
	РаботаСHTML_Клиент_ат.ИзменитьПометкиКнопок(Элементы.КомманднаяПанельКнопокРедактированияHTML_Предпросмотр, Элементы.Предпросмотр.Документ);	
	
	РаботаСHTML_Клиент_ат.ПерейтиПоСсылке(ДанныеСобытия.href);
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура НаУровеньВыше(Команда)
	
	ТекущиеДанные = Элементы.ДеревоРезультатов.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ТекущаяСтрока = ДеревоРезультатов.НайтиПоИдентификатору(Элементы.ДеревоРезультатов.ТекущаяСтрока);
	Родитель = ТекущаяСтрока.ПолучитьРодителя();
	
	Если НЕ Родитель = Неопределено Тогда
		
		РодительРодителя = Родитель.ПолучитьРодителя();
		
		Если РодительРодителя = Неопределено Тогда
			ЭлементыДерева = ДеревоРезультатов.ПолучитьЭлементы();
		Иначе
			ЭлементыДерева = РодительРодителя.ПолучитьЭлементы();
		КонецЕсли;
		
		НоваяСтрока = ЭлементыДерева.Добавить();
		
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекущиеДанные);
		
		Родитель.ПолучитьЭлементы().Удалить(ТекущаяСтрока);
		
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть();
	
КонецПроцедуры


#КонецОбласти 
