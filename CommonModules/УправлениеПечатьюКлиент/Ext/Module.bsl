﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Печать".
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Выполнить команду печати, которая открывает результат в форме печати документов.
//
// Если в параметре ПараметрыПечати передать структуру, содержащую свойство
// ПереопределитьПользовательскиеНастройкиКоличества = Истина, то пользовательские
// настройки количества копий не будут восстановлены, и не запишутся.
Процедура ВыполнитьКомандуПечати(ИмяМенеджераПечати, ИменаМакетов, ПараметрКоманды, ВладелецФормы, ПараметрыПечати = Неопределено) Экспорт
	
	// Проверим количество объектов
	Если НЕ ПроверитьКоличествоПереданныхОбъектов(ПараметрКоманды) Тогда
		Возврат;
	КонецЕсли;
	
	// Получим ключ уникальности открываемой формы
	КлючУникальности = Строка(Новый УникальныйИдентификатор);
	
	ПараметрыОткрытия = Новый Структура("ИмяМенеджераПечати,ИменаМакетов,ПараметрКоманды,ПараметрыПечати");
	ПараметрыОткрытия.ИмяМенеджераПечати = ИмяМенеджераПечати;
	ПараметрыОткрытия.ИменаМакетов		 = ИменаМакетов;
	ПараметрыОткрытия.ПараметрКоманды	 = ПараметрКоманды;
	ПараметрыОткрытия.ПараметрыПечати	 = ПараметрыПечати;
	
	// Откроем форму печати документов
	ОткрытьФорму("ОбщаяФорма.ПечатьДокументов", ПараметрыОткрытия, ВладелецФормы, КлючУникальности);
	
КонецПроцедуры

// Выполнить команду печати, которая результат выводит на принтер
Процедура ВыполнитьКомандуПечатиНаПринтер(ИмяМенеджераПечати, ИменаМакетов, ПараметрКоманды, ПараметрыПечати = Неопределено) Экспорт

	Перем ТабличныеДокументы, ОбъектыПечати, ПараметрыВывода, Адрес, ОбъектыПечатиСоотв, Отказ;
	
	Отказ = Ложь;
	
	// Проверим количество объектов
	Если НЕ ПроверитьКоличествоПереданныхОбъектов(ПараметрКоманды) Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыВывода = Неопределено;
	
	// Сформируем табличные документы
#Если ТолстыйКлиентОбычноеПриложение Тогда
	УправлениеПечатьюВызовСервера.СформироватьПечатныеФормыДляБыстройПечатиОбычноеПриложение(
			ИмяМенеджераПечати, ИменаМакетов, ПараметрКоманды, ПараметрыПечати,
			Адрес, ОбъектыПечатиСоотв, ПараметрыВывода, Отказ);
	Если НЕ Отказ Тогда
		ОбъектыПечати = Новый СписокЗначений;
		ТабличныеДокументы = ПолучитьИзВременногоХранилища(Адрес);
		Для Каждого ОбъектПечати Из ОбъектыПечатиСоотв Цикл
			ОбъектыПечати.Добавить(ОбъектПечати.Значение, ОбъектПечати.Ключ);
		КонецЦикла;
	КонецЕсли;
#Иначе
	УправлениеПечатьюВызовСервера.СформироватьПечатныеФормыДляБыстройПечати(
			ИмяМенеджераПечати, ИменаМакетов, ПараметрКоманды, ПараметрыПечати,
			ТабличныеДокументы, ОбъектыПечати, ПараметрыВывода, Отказ);
#КонецЕсли
	
	Если Отказ Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Нет прав для вывода печатной формы на принтер, обратитесь к администратору системы.'"));
		Возврат;
	КонецЕсли;
	
	// Распечатаем
	РаспечататьТабличныеДокументы(ТабличныеДокументы, ОбъектыПечати,
			ПараметрыВывода.ДоступнаПечатьПоКомплектно);
	
КонецПроцедуры

// Вывести табличные документы на принтер
Процедура РаспечататьТабличныеДокументы(ТабличныеДокументы, ОбъектыПечати, 
		Знач ДоступнаПечатьПокомплектно, Знач КоличествоКопийКомплектов = 1) Экспорт
	
	#Если ВебКлиент Тогда
		ДоступнаПечатьПокомплектно = Ложь;
	#КонецЕсли
	
	Если ДоступнаПечатьПокомплектно Тогда
		Для НомерКопииКомплекта = 1 По КоличествоКопийКомплектов Цикл
			Для Каждого ОбъектПечати Из ОбъектыПечати Цикл
				ИмяОбласти = ОбъектПечати.Представление;
				Для Каждого Элемент Из ТабличныеДокументы Цикл
					ТабДок = Элемент.Значение;
					ОбластьПечати = ТабДок.Области.Найти(ИмяОбласти);
					Если ОбластьПечати = Неопределено Тогда
						Продолжить;
					КонецЕсли;
					ОбластьПечатиПользователя = ТабДок.ОбластьПечати;
					ТабДок.ОбластьПечати = ОбластьПечати;
					ТабДок.Напечатать(РежимИспользованияДиалогаПечати.НеИспользовать);
					ТабДок.ОбластьПечати = ОбластьПечатиПользователя;
				КонецЦикла;
			КонецЦикла;
		КонецЦикла;
	Иначе
		Для Каждого Элемент Из ТабличныеДокументы Цикл
			ТабДок = Элемент.Значение;
			ТабДок.Напечатать(РежимИспользованияДиалогаПечати.НеИспользовать);
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

// Выполняет интерактивное проведение документов перед печатью.
// Если есть непроведенные документы, предлагает выполнить проведение. Спрашивает
// пользователя о продолжении, если какие-то из документов не провелись и имеются проведенные.
//
// Параметры
//  ДокументыМассив - Массив           - ссылки на документы, которые требуется провести перед печатью.
//                                       После выполнения функции из массива исключаются непроведенные документы.
//  ФормаИсточник   - УправляемаяФорма - форма, из которой было вызвана команда.
//
// Возвращаемое значение:
//  Булево - есть документы для печати в параметре ДокументыМассив.
//
Функция ПроверитьДокументыПроведены(ДокументыМассив, ФормаИсточник = Неопределено) Экспорт
	
	ОчиститьСообщения();
	ДокументыТребующиеПроведение = ОбщегоНазначенияВызовСервера.ПроверитьПроведенностьДокументов(ДокументыМассив);
	КоличествоНепроведенныхДокументов = ДокументыТребующиеПроведение.Количество();
	
	Если КоличествоНепроведенныхДокументов > 0 Тогда
		
		Если КоличествоНепроведенныхДокументов = 1 Тогда
			ТекстВопроса = НСтр("ru = 'Для того чтобы распечатать документ, его необходимо предварительно провести. Выполнить проведение документа и продолжить?'");
		Иначе
			ТекстВопроса = НСтр("ru = 'Для того чтобы распечатать документы, их необходимо предварительно провести. Выполнить проведение документов и продолжить?'");
		КонецЕсли;
		
		КодОтвета = Вопрос(ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		Если КодОтвета <> КодВозвратаДиалога.Да Тогда
			Возврат Ложь;
		КонецЕсли;
		
		ДанныеОНепроведенныхДокументах = ОбщегоНазначенияВызовСервера.ПровестиДокументы(ДокументыТребующиеПроведение);
		
		// сообщаем о документах, которые не провелись
		ШаблонСообщения = НСтр("ru = 'Документ %1 не проведен: %2 Печать невозможна.'");
		НепроведенныеДокументы = Новый Массив;
		Для Каждого ИнформацияОДокументе Из ДанныеОНепроведенныхДокументах Цикл
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСообщения, Строка(ИнформацияОДокументе.Ссылка), 
					ИнформацияОДокументе.ОписаниеОшибки), ИнформацияОДокументе.Ссылка);
			НепроведенныеДокументы.Добавить(ИнформацияОДокументе.Ссылка);		
		КонецЦикла;
		
		КоличествоНепроведенныхДокументов = НепроведенныеДокументы.Количество();
		
		// оповещаем открытые формы о том, что были проведены документы
		ПроведенныеДокументы = ОбщегоНазначенияКлиентСервер.СократитьМассив(ДокументыТребующиеПроведение, НепроведенныеДокументы);
		ТипыПроведенныхДокументов = Новый Соответствие;
		Для Каждого ПроведенныйДокумент Из ПроведенныеДокументы Цикл
			ТипыПроведенныхДокументов.Вставить(ТипЗнч(ПроведенныйДокумент));
		КонецЦикла;
		Для Каждого Тип Из ТипыПроведенныхДокументов Цикл
			ОповеститьОбИзменении(Тип.Ключ);
		КонецЦикла;
		
		// Если команда была вызвана из формы, то зачитываем в форму актуальную (проведенную) копию из базы.
		Если ТипЗнч(ФормаИсточник) = Тип("ФормаКлиентскогоПриложения") Тогда
			Попытка
				ФормаИсточник.Прочитать();
			Исключение
				// Если метода Прочитать нет, значит печать выполнена не из формы объекта.
			КонецПопытки;
		КонецЕсли;
		
		// обновляем исходный массив документов
		ДокументыМассив = ОбщегоНазначенияКлиентСервер.СократитьМассив(ДокументыМассив, НепроведенныеДокументы);

	КонецЕсли;
	
	ЕстьДокументыКоторыеМожноПечатать = ДокументыМассив.Количество() > 0;
	
	Отказ = Ложь;
	Если КоличествоНепроведенныхДокументов > 0 Тогда
		// спрашиваем пользователя о необходимости продолжения печати при наличии непроведенных документов
		
		ТекстДиалога = НСтр("ru = 'Не удалось провести один или несколько документов.'");
		КнопкиДиалога = Новый СписокЗначений;
		
		Если ЕстьДокументыКоторыеМожноПечатать Тогда
			ТекстДиалога = ТекстДиалога + " " + НСтр("ru = 'Продолжить?'");
			КнопкиДиалога.Добавить(КодВозвратаДиалога.Пропустить, НСтр("ru = 'Продолжить'"));
			КнопкиДиалога.Добавить(КодВозвратаДиалога.Отмена);
		Иначе
			КнопкиДиалога.Добавить(КодВозвратаДиалога.ОК);
		КонецЕсли;
		
		Ответ = Вопрос(ТекстДиалога, КнопкиДиалога);
		Если Ответ <> КодВозвратаДиалога.Пропустить Тогда
			Отказ = Истина;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Не Отказ;
	
КонецФункции

// Обработчик динамически подключаемой команды печати.
//
// Команда  - КомандаФормы - подключаемая команда формы, выполняющая обработчик Подключаемый_ВыполнитьКомандуПечати.
//            (альтернативный вызов*) Структура    - строка таблицы КомандыПечати, преобразованная в структуру.
// Источник - ТаблицаФормы Или ДанныеФормыСтруктура - источник объектов печати (Форма.Объект, Форма.Элементы.Список).
//            (альтернативный вызов*) Массив - список объектов печати.
//
// *Альтернативный вызов - указанные типы используются в случае, если вызов выполняется не из штатного
//                         обработчика Подключаемый_ВыполнитьКомандуПечати.
//
Процедура ВыполнитьПодключаемуюКомандуПечати(Знач Команда, Знач Форма, Знач Источник) Экспорт
	
	ОписаниеКоманды = Команда;
	Если ТипЗнч(Команда) = Тип("КомандаФормы") Тогда
		ОписаниеКоманды = УправлениеПечатьюКлиентПовтИсп.ОписаниеКомандыПечати(Команда.Имя, Форма.ИмяФормы);
	КонецЕсли;
	
	Если Не ОписаниеКоманды.НеВыполнятьЗаписьВФорме И ТипЗнч(Источник) = Тип("ДанныеФормыСтруктура")
		И (Источник.Ссылка.Пустая() Или Форма.Модифицированность) Тогда
		
		Если Источник.Ссылка.Пустая() Тогда
			ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Данные еще не записаны.
					|Выполнение действия ""%1"" возможно только после записи данных.
					|Данные будут записаны.'"),
				ОписаниеКоманды.Представление);
				Если Вопрос(ТекстВопроса, РежимДиалогаВопрос.ОКОтмена) = КодВозвратаДиалога.Отмена Тогда
					Возврат;
				КонецЕсли;
		КонецЕсли;
		
		Форма.Записать();
	КонецЕсли;
	
	ОбъектыПечати = Источник;
	Если ТипЗнч(Источник) <> Тип("Массив") Тогда
		ОбъектыПечати = ОбъектыПечати(Источник);
	КонецЕсли;

	Если ОписаниеКоманды.ПроверкаПроведенияПередПечатью
		И Не ПроверитьДокументыПроведены(ОбъектыПечати, Форма) Тогда
			Возврат;
	КонецЕсли;
	
	ОписаниеКоманды = ОбщегоНазначенияКлиентСервер.СкопироватьСтруктуру(ОписаниеКоманды);
	ОписаниеКоманды.Вставить("ОбъектыПечати", ОбъектыПечати);
	
	Если ОписаниеКоманды.МенеджерПечати = "СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки" 
		И ОбщегоНазначенияКлиентСервер.ПодсистемаСуществует("СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки") Тогда
			МодульДополнительныеОтчетыИОбработкиКлиент = ОбщегоНазначенияКлиентСервер.ОбщийМодуль("ДополнительныеОтчетыИОбработкиКлиент");
			МодульДополнительныеОтчетыИОбработкиКлиент.ВыполнитьНазначаемуюКомандуПечати(ОписаниеКоманды, Форма);
			Возврат;
	КонецЕсли;
		
	Если Не ПустаяСтрока(ОписаниеКоманды.Обработчик) Тогда
		ОписаниеКоманды.Вставить("Форма", Форма);
		ИмяОбработчика = ОписаниеКоманды.Обработчик;
		Обработчик = ИмяОбработчика + "(ОписаниеКоманды)";
		Результат = Вычислить(Обработчик);
		Возврат;
	КонецЕсли;
	
	Если ОписаниеКоманды.СразуНаПринтер Тогда
		ВыполнитьКомандуПечатиНаПринтер(ОписаниеКоманды.МенеджерПечати, ОписаниеКоманды.Идентификатор,
			ОбъектыПечати, ОписаниеКоманды.ДополнительныеПараметры);
	Иначе
		ВыполнитьКомандуПечати(ОписаниеКоманды.МенеджерПечати, ОписаниеКоманды.Идентификатор,
			ОбъектыПечати, Форма, ОписаниеКоманды);
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Работа с макетами офисных документов
//
//	Краткое описание:
//	Секция содержит интерфейсные функции (API), используемые при создании
//	печатных форм основанных на офисных документах. На данный момент поддерживается
//	два офисных пакета MS Office (шаблоны MS Word) и Open Office (шаблоны OO Writer).
//
////////////////////////////////////////////////////////////////////////////////
//	типы используемых данных (определяется конкретными реализациями)
//	СсылкаПечатнаяФорма	- ссылка на печатную форму
//	СсылкаМакет			- ссылка на макет
//	Область				- ссылка на область в печатной форме или макете (структура)
//						доопределяется в интерфейсном модуле служебной информацией
//						об области
//	ОписаниеОбласти			- описание области макета (см. ниже)
//	ДанныеЗаполнения		- либо структура, либо массив структур (для случая
//							списков и таблиц
////////////////////////////////////////////////////////////////////////////////
//	ОписаниеОбласти - структура, описывающая подготовленные пользователем области макета
//	ключ ИмяОбласти - имя области
//	ключ ТипТипОбласти - 	ВерхнийКолонтитул
//							НижнийКолонтитул
//							Общая
//							СтрокаТаблицы
//							Список
//

////////////////////////////////////////////////////////////////////////////////
// Функции инициализации и закрытия ссылок

// Создает соединение с выходной печатной формой.
// Необходимо вызвать перед любыми действиями над формой.
// Параметры:
// ТипДокумента            - Строка - тип печатной формы "DOC" или "ODT";
// НастройкиСтраницыМакета - Соответствие - параметры из структуры, возвращаемой функцией ИнициализироватьМакет;
// Макет                   - Структура - результат функции ИнициализироватьМакет.
//
// Возвращаемое значение:
//  Структура.
// 
// Примечание: параметр НастройкиСтраницыМакета устарел, его следует пропускать и использовать параметр Макет.
//
Функция ИнициализироватьПечатнуюФорму(знач ТипДокумента, знач НастройкиСтраницыМакета = Неопределено, Макет = Неопределено) Экспорт
	
	Если ВРег(ТипДокумента) = "DOC" Тогда
		Параметр = ?(Макет = Неопределено, НастройкиСтраницыМакета, Макет); // для обратной совместимости
		ПечатнаяФорма = УправлениеПечатьюMSWordКлиент.ИнициализироватьПечатнуюФормуMSWord(Параметр);
		ПечатнаяФорма.Вставить("Тип", "DOC");
		ПечатнаяФорма.Вставить("ПоследняяВыведеннаяОбласть", Неопределено);
		Возврат ПечатнаяФорма;
	ИначеЕсли ВРег(ТипДокумента) = "ODT" Тогда
		ПечатнаяФорма = УправлениеПечатьюOOWriterКлиент.ИнициализироватьПечатнуюФормуOOWriter(Макет);
		ПечатнаяФорма.Вставить("Тип", "ODT");
		ПечатнаяФорма.Вставить("ПоследняяВыведеннаяОбласть", Неопределено);
		Возврат ПечатнаяФорма;
	КонецЕсли;
	
КонецФункции

// Создает соединение с макетом. В дальнейшем это соединение используется
// при получении из него областей (тегов и таблиц).
//
// Параметры:
//  ДвоичныеДанныеМакета - ДвоичныеДанные - двоичные данные макета
//  ТипМакета            - Строка - тип макета печатной формы "DOC" или "ODT";
// Возвращаемое значение:
//  Структура.
//
Функция ИнициализироватьМакет(знач ДвоичныеДанныеМакета, знач ТипМакета, знач ПутьККаталогу = "", знач ИмяМакета = "") Экспорт
	
#Если ВебКлиент Тогда
	ТекстСообщения = НСтр("ru = 'Для продолжения печати необходимо установить расширение работы с файлами.'");
	Если Не ОбщегоНазначенияКлиент.РасширениеРаботыСФайламиПодключено(ТекстСообщения) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Если ПустаяСтрока(ИмяМакета) Тогда
		ИмяВременногоФайла = Строка(Новый УникальныйИдентификатор) + "." + НРег(ТипМакета);
	Иначе
		ИмяВременногоФайла = ИмяМакета + "." + НРег(ТипМакета);
	КонецЕсли;
	
	ПолучаемыеФайлы = Новый Соответствие;
	ПолучаемыеФайлы.Вставить(ИмяВременногоФайла, ДвоичныеДанныеМакета);
	
	Результат = ПолучитьФайлыВКаталогФайловПечати(ПутьККаталогу, ПолучаемыеФайлы);
	
	Если Результат = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ИмяВременногоФайла = Результат + ИмяВременногоФайла;
#Иначе
	ИмяВременногоФайла = "";
#КонецЕсли

	Если ВРег(ТипМакета) = "DOC" Тогда
		Макет = УправлениеПечатьюMSWordКлиент.ПолучитьМакетMSWord(ДвоичныеДанныеМакета, ИмяВременногоФайла);
		Макет.Вставить("Тип", "DOC");
		Возврат Макет;
	ИначеЕсли ВРег(ТипМакета) = "ODT" Тогда
		Макет = УправлениеПечатьюOOWriterКлиент.ПолучитьМакетOOWriter(ДвоичныеДанныеМакета, ИмяВременногоФайла);
		Макет.Вставить("Тип", "ODT");
		Макет.Вставить("НастройкиСтраницыМакета", Неопределено);
		Возврат Макет;
	КонецЕсли;
	
КонецФункции

// Освобождает ссылки в созданном интерфейсе связи с офисным приложением.
// Необходимо вызывать каждый раз после завершения формирования макета и выводе
// печатной формы пользователю.
// Параметры:
// Handler - СсылкаПечатнаяФорма, СсылкаМакет
// ЗакрытьПриложение - булево - признак, требуется ли закрыть приложение.
//					Соединение с макетом требуется закрывать с закрытием приложения.
//					ПечатнуюФорму не требуется закрывать.
//
Процедура ОчиститьСсылки(Handler, знач ЗакрытьПриложение = Истина) Экспорт
	
	Если Handler <> Неопределено Тогда
		Если Handler.Тип = "DOC" Тогда
			УправлениеПечатьюMSWordКлиент.ЗакрытьСоединение(Handler, ЗакрытьПриложение);
		Иначе
			УправлениеПечатьюOOWriterКлиент.ЗакрытьСоединение(Handler, ЗакрытьПриложение);
		КонецЕсли;
		Handler = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Функция отображения печатной формы пользователю

// Показывает сформированный документ пользователю.
// Фактически устанавливает ему признак видимости.
// Параметры
//  Handler - СсылкаПечатнаяФорма
//
Процедура ПоказатьДокумент(знач Handler) Экспорт
	
	Если Handler.Тип = "DOC" Тогда
		УправлениеПечатьюMSWordКлиент.ПоказатьДокументMSWord(Handler);
	ИначеЕсли Handler.Тип = "ODT" Тогда
		УправлениеПечатьюOOWriterКлиент.ПоказатьДокументOOWriter(Handler);
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Функции получения областей из макета, вывода в печатную форму областей макета
// и заполнение параметров в них

// Получает область из макета.
// Параметры
// СсылкаМакет - СсылкаМакет - ссылка на макет
// ОписаниеОбласти - ОписаниеОбласти - описание области
//
// Возвращаемое значение
// Область - область из макета
//
Функция ПолучитьОбласть(знач СсылкаМакет, знач ОписаниеОбласти) Экспорт
	
	Область = Неопределено;
	Если СсылкаМакет.Тип = "DOC" Тогда
		
		Если		ОписаниеОбласти.ТипОбласти = "ВерхнийКолонтитул" Тогда
			Область = УправлениеПечатьюMSWordКлиент.ПолучитьОбластьВерхнегоКолонтитула(СсылкаМакет);
		ИначеЕсли	ОписаниеОбласти.ТипОбласти = "НижнийКолонтитул" Тогда
			Область = УправлениеПечатьюMSWordКлиент.ПолучитьОбластьНижнегоКолонтитула(СсылкаМакет);
		ИначеЕсли	ОписаниеОбласти.ТипОбласти = "Общая" Тогда
			Область = УправлениеПечатьюMSWordКлиент.ПолучитьОбластьМакетаMSWord(СсылкаМакет, ОписаниеОбласти.ИмяОбласти, 1, 0);
		ИначеЕсли	ОписаниеОбласти.ТипОбласти = "СтрокаТаблицы" Тогда
			Область = УправлениеПечатьюMSWordКлиент.ПолучитьОбластьМакетаMSWord(СсылкаМакет, ОписаниеОбласти.ИмяОбласти);
		ИначеЕсли	ОписаниеОбласти.ТипОбласти = "Список" Тогда
			Область = УправлениеПечатьюMSWordКлиент.ПолучитьОбластьМакетаMSWord(СсылкаМакет, ОписаниеОбласти.ИмяОбласти, 1, 0);
		Иначе
			ВызватьИсключение
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Тип области не указан или указан не корректно: %1.'"), ОписаниеОбласти.ТипОбласти);
		КонецЕсли;
		
		Если Область <> Неопределено Тогда
			Область.Вставить("ОписаниеОбласти", ОписаниеОбласти);
		КонецЕсли;
	ИначеЕсли СсылкаМакет.Тип = "ODT" Тогда
		
		Если		ОписаниеОбласти.ТипОбласти = "ВерхнийКолонтитул" Тогда
			Область = УправлениеПечатьюOOWriterКлиент.ПолучитьОбластьВерхнегоКолонтитула(СсылкаМакет);
		ИначеЕсли	ОписаниеОбласти.ТипОбласти = "НижнийКолонтитул" Тогда
			Область = УправлениеПечатьюOOWriterКлиент.ПолучитьОбластьНижнегоКолонтитула(СсылкаМакет);
		ИначеЕсли	ОписаниеОбласти.ТипОбласти = "Общая"
				ИЛИ ОписаниеОбласти.ТипОбласти = "СтрокаТаблицы"
				ИЛИ ОписаниеОбласти.ТипОбласти = "Список" Тогда
			Область = УправлениеПечатьюOOWriterКлиент.ПолучитьОбластьМакета(СсылкаМакет, ОписаниеОбласти.ИмяОбласти);
		Иначе
			ВызватьИсключение
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Тип области не указан или указан не корректно: %1.'"), ОписаниеОбласти.ИмяОбласти);
		КонецЕсли;
		
		Если Область <> Неопределено Тогда
			Область.Вставить("ОписаниеОбласти", ОписаниеОбласти);
		КонецЕсли;
	КонецЕсли;
	
	Возврат Область;
	
КонецФункции

// Присоединяет область в печатную форму из макета.
// Применяется при одиночном выводе области.
//
// Параметры
// ПечатнаяФорма - СсылкаПечатнаяФорма - ссылка на печатную форму
// ОбластьМакета - Область - область из макета
// ПереходНаСледующуюСтроку - булево, требуется ли вставлять разрыв после вывода области
//
Процедура ПрисоединитьОбласть(знач ПечатнаяФорма,
							  знач ОбластьМакета,
							  знач ПереходНаСледующуюСтроку = Истина) Экспорт
							  
	Если ОбластьМакета = Неопределено Тогда
		Возврат;						  
	КонецЕсли;
								  
	Попытка
		ОписаниеОбласти = ОбластьМакета.ОписаниеОбласти;
		
		Если ПечатнаяФорма.Тип = "DOC" Тогда
			
			ВыведеннаяОбласть = Неопределено;
			
			Если		ОписаниеОбласти.ТипОбласти = "ВерхнийКолонтитул" Тогда
				УправлениеПечатьюMSWordКлиент.ДобавитьВерхнийКолонтитул(ПечатнаяФорма, ОбластьМакета);
			ИначеЕсли	ОписаниеОбласти.ТипОбласти = "НижнийКолонтитул" Тогда
				УправлениеПечатьюMSWordКлиент.ДобавитьНижнийКолонтитул(ПечатнаяФорма, ОбластьМакета);
			ИначеЕсли	ОписаниеОбласти.ТипОбласти = "Общая" Тогда
				ВыведеннаяОбласть = УправлениеПечатьюMSWordКлиент.ПрисоединитьОбласть(ПечатнаяФорма, ОбластьМакета, ПереходНаСледующуюСтроку);
			ИначеЕсли	ОписаниеОбласти.ТипОбласти = "Список" Тогда
				ВыведеннаяОбласть = УправлениеПечатьюMSWordКлиент.ПрисоединитьОбласть(ПечатнаяФорма, ОбластьМакета, ПереходНаСледующуюСтроку);
			ИначеЕсли	ОписаниеОбласти.ТипОбласти = "СтрокаТаблицы" Тогда
				Если ПечатнаяФорма.ПоследняяВыведеннаяОбласть <> Неопределено
				   И ПечатнаяФорма.ПоследняяВыведеннаяОбласть.ТипОбласти = "СтрокаТаблицы"
				   И НЕ ПечатнаяФорма.ПоследняяВыведеннаяОбласть.ПереходНаСледующуюСтроку Тогда
					ВыведеннаяОбласть = УправлениеПечатьюMSWordКлиент.ПрисоединитьОбласть(ПечатнаяФорма, ОбластьМакета, ПереходНаСледующуюСтроку, Истина);
				Иначе
					ВыведеннаяОбласть = УправлениеПечатьюMSWordКлиент.ПрисоединитьОбласть(ПечатнаяФорма, ОбластьМакета, ПереходНаСледующуюСтроку);
				КонецЕсли;
			Иначе
				ВызватьИсключение(НСтр("ru = 'Тип области не указан или указан не корректно.'"));
			КонецЕсли;
			
			ОписаниеОбласти.Вставить("Область", ВыведеннаяОбласть);
			ОписаниеОбласти.Вставить("ПереходНаСледующуюСтроку", ПереходНаСледующуюСтроку);
			
			ПечатнаяФорма.ПоследняяВыведеннаяОбласть = ОписаниеОбласти; // содержит тип области, и границы области (если требуется)
			
		ИначеЕсли ПечатнаяФорма.Тип = "ODT" Тогда
			Если		ОписаниеОбласти.ТипОбласти = "ВерхнийКолонтитул" Тогда
				УправлениеПечатьюOOWriterКлиент.ДобавитьВерхнийКолонтитул(ПечатнаяФорма, ОбластьМакета);
			ИначеЕсли	ОписаниеОбласти.ТипОбласти = "НижнийКолонтитул" Тогда
				УправлениеПечатьюOOWriterКлиент.ДобавитьНижнийКолонтитул(ПечатнаяФорма, ОбластьМакета);
			ИначеЕсли	ОписаниеОбласти.ТипОбласти = "Общая"
					ИЛИ ОписаниеОбласти.ТипОбласти = "Список" Тогда
				УправлениеПечатьюOOWriterКлиент.УстановитьОсновнойКурсорНаТелоДокумента(ПечатнаяФорма);
				УправлениеПечатьюOOWriterКлиент.ПрисоединитьОбласть(ПечатнаяФорма, ОбластьМакета, ПереходНаСледующуюСтроку);
			ИначеЕсли	ОписаниеОбласти.ТипОбласти = "СтрокаТаблицы" Тогда
				УправлениеПечатьюOOWriterКлиент.УстановитьОсновнойКурсорНаТелоДокумента(ПечатнаяФорма);
				УправлениеПечатьюOOWriterКлиент.ПрисоединитьОбласть(ПечатнаяФорма, ОбластьМакета, ПереходНаСледующуюСтроку, Истина);
			Иначе
				ВызватьИсключение(НСтр("ru = 'Тип области не указан или указан не корректно'"));
			КонецЕсли;
			ПечатнаяФорма.ПоследняяВыведеннаяОбласть = ОписаниеОбласти; // содержит тип области, и границы области (если требуется)
		КонецЕсли;
	Исключение
		СообщениеОбОшибке = СокрЛП(КраткоеПредставлениеОшибки(ИнформацияОбОШибке()));
		СообщениеОбОшибке = ?(Прав(СообщениеОбОшибке, 1) = ".", СообщениеОбОшибке, СообщениеОбОшибке + ".");
		СообщениеОбОшибке = СообщениеОбОшибке + " " +
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Ошибка при попытке вывести область ""%1"" из макета.'"),
					ОбластьМакета.ОписаниеОбласти.ИмяОбласти);
		ВызватьИсключение СообщениеОбОшибке;
	КонецПопытки;
	
КонецПроцедуры

// Заполняет параметры области печатной формы
//
// Параметры
// ПечатнаяФорма	- СсылкаПечатнаяФорма, Область - область печатной формы, либо сама печатная форма
// Данные			- ДанныеЗаполнения
//
Процедура ЗаполнитьПараметры(знач ПечатнаяФорма, знач Данные) Экспорт
	
	ОписаниеОбласти = ПечатнаяФорма.ПоследняяВыведеннаяОбласть;
	
	Если ПечатнаяФорма.Тип = "DOC" Тогда
		Если		ОписаниеОбласти.ТипОбласти = "ВерхнийКолонтитул" Тогда
			УправлениеПечатьюMSWordКлиент.ЗаполнитьПараметрыВерхнегоКолонтитула(ПечатнаяФорма, Данные);
		ИначеЕсли	ОписаниеОбласти.ТипОбласти = "НижнийКолонтитул" Тогда
			УправлениеПечатьюMSWordКлиент.ЗаполнитьПараметрыНижнегоКолонтитула(ПечатнаяФорма, Данные);
		ИначеЕсли	ОписаниеОбласти.ТипОбласти = "Общая"
				ИЛИ ОписаниеОбласти.ТипОбласти = "СтрокаТаблицы"
				ИЛИ ОписаниеОбласти.ТипОбласти = "Список" Тогда
			УправлениеПечатьюMSWordКлиент.ЗаполнитьПараметры(ПечатнаяФорма.ПоследняяВыведеннаяОбласть.Область, Данные);
		Иначе
			ВызватьИсключение(НСтр("ru = 'Тип области не указан или указан не корректно'"));
		КонецЕсли;
	ИначеЕсли ПечатнаяФорма.Тип = "ODT" Тогда
		Если		ПечатнаяФорма.ПоследняяВыведеннаяОбласть.ТипОбласти = "ВерхнийКолонтитул" Тогда
			УправлениеПечатьюOOWriterКлиент.УстановитьОсновнойКурсорНаВерхнийКолонтитул(ПечатнаяФорма);
		ИначеЕсли	ПечатнаяФорма.ПоследняяВыведеннаяОбласть.ТипОбласти = "НижнийКолонтитул" Тогда
			УправлениеПечатьюOOWriterКлиент.УстановитьОсновнойКурсорНаНижнийКолонтитул(ПечатнаяФорма);
		ИначеЕсли	ОписаниеОбласти.ТипОбласти = "Общая"
				ИЛИ ОписаниеОбласти.ТипОбласти = "СтрокаТаблицы"
				ИЛИ ОписаниеОбласти.ТипОбласти = "Список" Тогда
			УправлениеПечатьюOOWriterКлиент.УстановитьОсновнойКурсорНаТелоДокумента(ПечатнаяФорма);
		КонецЕсли;
		УправлениеПечатьюOOWriterКлиент.ЗаполнитьПараметры(ПечатнаяФорма, Данные);
	КонецЕсли;
	
КонецПроцедуры

// Добавляет область в печатную форму из макета, при этом заменяя
// параметры в области значениями из данных объекта.
// Применяется при одиночном выводе области.
//
// Параметры
// ПечатнаяФорма	- СсылкаПечатнаяФорма
// ОбластьМакета	- Область
// Данные			- ДанныеОбъекта
// ПереходНаСледСтроку - булево, требуется ли вставлять разрыв после вывода области
//
Процедура ПрисоединитьОбластьИЗаполнитьПараметры(знач ПечатнаяФорма,
										знач ОбластьМакета,
										знач Данные,
										знач ПереходНаСледующуюСтроку = Истина) Экспорт
																			
	Если ОбластьМакета <> Неопределено Тогда
		ПрисоединитьОбласть(ПечатнаяФорма, ОбластьМакета, ПереходНаСледующуюСтроку);
		ЗаполнитьПараметры(ПечатнаяФорма, Данные)
	КонецЕсли;
	
КонецПроцедуры

// Добавляет область в печатную форму из макета, при этом заменяя
// параметры в области значениями из данных объекта.
// Применяется при одиночном выводе области.
//
// Параметры
// ПечатнаяФорма	- СсылкаПечатнаяФорма
// ОбластьМакета	- Область - область макета
// Данные			- ДанныеОбъекта (массив структур)
// ПереходНаСледСтроку - булево, требуется ли вставлять разрыв после вывода области
//
Процедура ПрисоединитьИЗаполнитьКоллекцию(знач ПечатнаяФорма,
										знач ОбластьМакета,
										знач Данные,
										знач ПереходНаСледСтроку = Истина) Экспорт
	Если ОбластьМакета = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ОписаниеОбласти = ОбластьМакета.ОписаниеОбласти;
	
	Если ПечатнаяФорма.Тип = "DOC" Тогда
		Если		ОписаниеОбласти.ТипОбласти = "СтрокаТаблицы" Тогда
			УправлениеПечатьюMSWordКлиент.ПрисоединитьИЗаполнитьОбластьТаблицы(ПечатнаяФорма, ОбластьМакета, Данные, ПереходНаСледСтроку);
		ИначеЕсли	ОписаниеОбласти.ТипОбласти = "Список" Тогда
			УправлениеПечатьюMSWordКлиент.ПрисоединитьИЗаполнитьНабор(ПечатнаяФорма, ОбластьМакета, Данные, ПереходНаСледСтроку);
		Иначе
			ВызватьИсключение(НСтр("ru = 'Тип области не указан или указан не корректно'"));
		КонецЕсли;
	ИначеЕсли ПечатнаяФорма.Тип = "ODT" Тогда
		Если		ОписаниеОбласти.ТипОбласти = "СтрокаТаблицы" Тогда
			УправлениеПечатьюOOWriterКлиент.ПрисоединитьИЗаполнитьКоллекцию(ПечатнаяФорма, ОбластьМакета, Данные, Истина, ПереходНаСледСтроку);
		ИначеЕсли	ОписаниеОбласти.ТипОбласти = "Список" Тогда
			УправлениеПечатьюOOWriterКлиент.ПрисоединитьИЗаполнитьКоллекцию(ПечатнаяФорма, ОбластьМакета, Данные, Ложь, ПереходНаСледСтроку);
		Иначе
			ВызватьИсключение(НСтр("ru = 'Тип области не указан или указан не корректно'"));
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// Вставляет разрыв между строками в виде символа перевода строки
// Параметры
// ПечатнаяФорма - СсылкаПечатнаяФорма
//
Процедура ВставитьРазрывНаНовуюСтроку(знач ПечатнаяФорма) Экспорт
	
	Если	  ПечатнаяФорма.Тип = "DOC" Тогда
		УправлениеПечатьюMSWordКлиент.ВставитьРазрывНаНовуюСтроку(ПечатнаяФорма);
	ИначеЕсли ПечатнаяФорма.Тип = "ODT" Тогда
		УправлениеПечатьюOOWriterКлиент.ВставитьРазрывНаНовуюСтроку(ПечатнаяФорма);
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Перед выполнением команды печати проверить, был ли передан хотя бы один объект, так как
// для команд с множественным режимом использования может быть передан пустой массив.
Функция ПроверитьКоличествоПереданныхОбъектов(ПараметрКоманды)
	
	Если ТипЗнч(ПараметрКоманды) = Тип("Массив") И ПараметрКоманды.Количество() = 0 Тогда
		Возврат Ложь;
	Иначе
		Возврат Истина;
	КонецЕсли;
	
КонецФункции

#Если ВебКлиент Тогда
// Функция получает файл(ы) c сервера в локальный каталог на диск и возвращает
// имя каталога, в который они были сохранены
// Параметры:
// ПутьККаталогу - строка - путь к каталогу, в который должны быть сохранены файлы
// ПолучаемыеФайлы - соответствие - 
//                         ключ  - имя файла
//                         значение - двоичные данные файла
//
Функция ПолучитьФайлыВКаталогФайловПечати(ПутьККаталогу, ПолучаемыеФайлы) Экспорт
	
	ТребуетсяУстановитьКаталогПечати = Не ЗначениеЗаполнено(ПутьККаталогу);
	Если Не ТребуетсяУстановитьКаталогПечати Тогда
		Файл = Новый Файл(ПутьККаталогу);
		Если НЕ Файл.Существует() Тогда
			ТребуетсяУстановитьКаталогПечати = Истина;
		КонецЕсли;
	КонецЕсли;
	
	Если ТребуетсяУстановитьКаталогПечати Тогда
		Результат = ОткрытьФормуМодально("РегистрСведений.ПользовательскиеМакетыПечати.Форма.НастройкаКаталогаФайловПечати");
		Если ТипЗнч(Результат) <> Тип("Строка") Тогда
			Возврат Неопределено;
		КонецЕсли;
		ПутьККаталогу = Результат;
	КонецЕсли;
	
	ПовторятьПечать = Истина;
	
	Пока ПовторятьПечать Цикл
		ПовторятьПечать = Ложь;
		Попытка
			ФайлыВоВременномХранилище = ПолучитьАдресаФайловВоВременномХранилище(ПолучаемыеФайлы);
			
			ОписанияФайлов = Новый Массив;
			
			Для Каждого ФайлВоВременномХранилище Из ФайлыВоВременномХранилище Цикл
				ОписанияФайлов.Добавить(Новый ОписаниеПередаваемогоФайла(ФайлВоВременномХранилище.Ключ,ФайлВоВременномХранилище.Значение));
			КонецЦикла;
			
			Если НЕ ПолучитьФайлы(ОписанияФайлов, , ПутьККаталогу, Ложь) Тогда
				Возврат Неопределено;
			КонецЕсли;
		Исключение
			СообщениеОбОшибке = КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
			Результат = ОткрытьФормуМодально("РегистрСведений.ПользовательскиеМакетыПечати.Форма.ДиалогПовтораПечати", Новый Структура("СообщениеОбОшибке", СообщениеОбОшибке));
			Если ТипЗнч(Результат) = Тип("Строка") Тогда
				ПовторятьПечать = Истина;
				ПутьККаталогу = Результат;
			Иначе
				Возврат Неопределено;
			КонецЕсли;
		КонецПопытки;
	КонецЦикла;
	
	Если Прав(ПутьККаталогу, 1) <> "\" Тогда
		ПутьККаталогу = ПутьККаталогу + "\";
	КонецЕсли;
	
	Возврат ПутьККаталогу;
	
КонецФункции

// Помещает набор двоичных данных во временное хранилище
// Параметры:
// 	НаборЗначений - соответствие, ключ - ключ, связанный с двоичными данными
// 								  значение - ДвоичныеДанные
// Возвращаемое значение:
// соответствие: ключ - ключ, связанный с адресом во временном хранилище
//               значение - адрес во временном хранилище
//
Функция ПолучитьАдресаФайловВоВременномХранилище(НаборЗначений)
	
	Результат = Новый Соответствие;
	
	Для Каждого КлючЗначение Из НаборЗначений Цикл
		Результат.Вставить(КлючЗначение.Ключ, ПоместитьВоВременноеХранилище(КлючЗначение.Значение));
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции
#КонецЕсли

// Возвращает ссылки на объекты, выбранные в данный момент на форме.
Функция ОбъектыПечати(Источник)
	
	Результат = Новый Массив;
	
	Если ТипЗнч(Источник) = Тип("ТаблицаФормы") Тогда
		ВыделенныеСтроки = Источник.ВыделенныеСтроки;
		Для Каждого ВыделеннаяСтрока Из ВыделенныеСтроки Цикл
			Если ТипЗнч(ВыделеннаяСтрока) = Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
				Продолжить;
			КонецЕсли;
			ТекущаяСтрока = Источник.ДанныеСтроки(ВыделеннаяСтрока);
			Если ТекущаяСтрока <> Неопределено Тогда
				Результат.Добавить(ТекущаяСтрока.Ссылка);
			КонецЕсли;
		КонецЦикла;
	Иначе
		Результат.Добавить(Источник.Ссылка);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

