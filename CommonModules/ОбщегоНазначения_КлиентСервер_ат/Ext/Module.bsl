﻿
// Для возможности проверки мутабельных значений.
Функция   ПустоеЗначение(Значение) Экспорт

	Если Значение = Неопределено ИЛИ Значение = Null Тогда
		Возврат Истина;
	Иначе
		Попытка
			Возврат НЕ ЗначениеЗаполнено(Значение);
		Исключение
			Возврат Ложь;
		КонецПопытки;
	КонецЕсли;

КонецФункции

Функция   ПустоеСодержаниеФорматированногоДокумента(ФорматированныйДокумент) Экспорт
	
	Если НЕ ПустаяСтрока(ФорматированныйДокумент.ПолучитьТекст()) Тогда
		
		Возврат Ложь;
		
	КонецЕсли;
	
	ТекстХТМЛ = "";
	СтруктураВложений = Новый Структура;
	ФорматированныйДокумент.ПолучитьHTML(ТекстХТМЛ, СтруктураВложений);
	
	Если СтруктураВложений.Количество() > 0 Тогда
		
		Возврат Ложь;
		
	КонецЕсли;
	
	Построитель = Новый ПостроительDOM;
	ЧтениеHTML = Новый ЧтениеHTML;
	ЧтениеHTML.УстановитьСтроку(ТекстХТМЛ);
	
	ДокументHTML = Построитель.Прочитать(ЧтениеHTML);
	
	Возврат ДокументHTML.Картинки.Количество() = 0;
	
КонецФункции

Функция   ПустоеСодержаниеHTML(ТекстHTML) Экспорт
	
	Если ПустаяСтрока(ТекстHTML) Тогда
		
		Возврат Истина;
		
	КонецЕсли;
	
	ДокументHTML = РаботаСHTML_КлиентСервер_ат.ПолучитьОбъектДокументHTMLИзТекстаHTML(ТекстHTML);
	
	Возврат ПустаяСтрока(ДокументHTML.Тело.ТекстовоеСодержимое) И ДокументHTML.Картинки.Количество() = 0;
	
КонецФункции

// Присваивает Новое значение переменной Текущее если они неравны. Возвращает Текущее до возможного присвоения.
Функция   ПрисвоитьНеравное(Текущее, Новое) Экспорт
	
	Если НЕ Текущее = Новое Тогда
		Было = Текущее;
		Текущее = Новое;
		Возврат Было;
	Иначе
		Возврат Текущее;
	КонецЕсли;
	
КонецФункции

Функция   ИмяКлассаИзИмениТипаОбъектаМетаданных(ИмяТипаОбъекта) Экспорт

	ИмяКласса = Неопределено;
	
	Если ВРег(ИмяТипаОбъекта) = "КОНСТАНТЫ" Тогда  
		                         
		ИмяКласса = "Константы";
		
	ИначеЕсли ВРег(ИмяТипаОбъекта) = "СПРАВОЧНИК" Тогда  

		ИмяКласса = "Справочники";
		
	ИначеЕсли ВРег(ИмяТипаОбъекта) = "ДОКУМЕНТ" Тогда   
		
		ИмяКласса = "Документы";
		
	ИначеЕсли ВРег(ИмяТипаОбъекта) = "ПЛАНВИДОВХАРАКТЕРИСТИК" Тогда
		
		ИмяКласса = "ПланыВидовХарактеристик";
		
	ИначеЕсли ВРег(ИмяТипаОбъекта) = "ПЛАНСЧЕТОВ" Тогда
		
		ИмяКласса = "ПланыСчетов"; 
		
	ИначеЕсли ВРег(ИмяТипаОбъекта) = "ПЛАНВИДОВРАСЧЕТА" Тогда
		
		ИмяКласса = "ПланыВидовРасчета"; 
		
	ИначеЕсли ВРег(ИмяТипаОбъекта) = "БИЗНЕСПРОЦЕСС" Тогда 
		
		ИмяКласса = "БизнесПроцессы";
		
	ИначеЕсли ВРег(ИмяТипаОбъекта) = "ЗАДАЧА" Тогда 
		
		ИмяКласса = "Задачи";  	
		
	ИначеЕсли ВРег(ИмяТипаОбъекта) = "ПЛАНОБМЕНА" Тогда 		
		
		ИмяКласса = "ПланыОбмена";
		
	ИначеЕсли ВРег(ИмяТипаОбъекта) = "ПОСЛЕДОВАТЕЛЬНОСТЬ" Тогда 			
		
		ИмяКласса = "Последовательности"; 	
		
	ИначеЕсли ВРег(ИмяТипаОбъекта) = "РЕГИСТРСВЕДЕНИЙ" Тогда
		
		ИмяКласса = "РегистрыСведений";
		
	ИначеЕсли ВРег(ИмяТипаОбъекта) = "РЕГИСТРНАКОПЛЕНИЯ" Тогда
		
		ИмяКласса = "РегистрыНакопления";
		
	ИначеЕсли ВРег(ИмяТипаОбъекта) = "РЕГИСТРБУХГАЛТЕРИИ" Тогда
		
		ИмяКласса = "РегистрыБухгалтерии";
		
	ИначеЕсли ВРег(ИмяТипаОбъекта) = "РЕГИСТРРАСЧЕТА" Тогда 
		
		ИмяКласса = "РегистрыРасчета";
		
	КонецЕсли;
	
    Возврат ИмяКласса;

КонецФункции

// Устанавливает переданное значение реквизиту по переданному пути.
// Параметры:
//	Форма - УправляемаяФорма, Форма - Форма в которой будет произведен поиск реквизита.
//	ПутьРеквизита - Строка - Путь к данным, например: "Объект.Наименование".
//	Значение - Произвольный - Значение которое будет присвоено реквизиту.
//	ТолькоЕслиНеЗаполнен - Булево - Реквизит будет заполнен только если он не заполнен.
//
Процедура УстановитьЗначениеРеквизитаФормыПоПути(Форма, ПутьРеквизита, Значение, ТолькоЕслиНеЗаполнен = Ложь) Экспорт
	
	МассивПодстрок = Системный_КлиентСервер_Переопределяемый_ат.РазложитьСтрокуВМассивПодстрок(ПутьРеквизита, ".");
	
	Путь = Форма;
	ИмяРеквизита = МассивПодстрок[МассивПодстрок.Количество() - 1];
	
	Для Сч = 0 По МассивПодстрок.Количество() - 2 Цикл
		
		Путь = Путь[МассивПодстрок[Сч]];
		
	КонецЦикла;
	
	Если НЕ ТолькоЕслиНеЗаполнен ИЛИ НЕ ЗначениеЗаполнено(Путь[ИмяРеквизита]) Тогда
		
		Путь[ИмяРеквизита] = Значение;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура УстановитьЗаголовокСистемы_ат() Экспорт
	
	ЗаголовокПриложения = ОбщегоНазначения_ВызовСервера_ат.СформироватьЗаголовокСистемы();
	Попытка // копия кода из БСП.ОМ.СтандартныеПодсистемыКлиент.Процедура УстановитьРасширенныйЗаголовокПриложения
#Если ВебКлиент Тогда
		Результат = Вычислить("УстановитьЗаголовокКлиентскогоПриложения(ЗаголовокПриложения)");
		// каким хреном процедура в вебе что-то возвращает и на кой муть с этими Вычислить/Выполнить - мне не ведомо,
		// но гуру БСП, видимо, в курсе требуемого шаманства, и оспаривать их эзотерику у меня нет ни малейшего желания.
		// при обновлении БСП - посматривать, не сменили ли авторам лекарства и не придумали ли они другие чудеса
#Иначе
		Выполнить("УстановитьЗаголовокКлиентскогоПриложения(ЗаголовокПриложения)");
#КонецЕсли
	Исключение // поддержка старых версий 1С (8.2-)
#Если ВебКлиент Тогда
		Результат = Вычислить("УстановитьЗаголовокПриложения(ЗаголовокПриложения)");
#Иначе
		Выполнить("УстановитьЗаголовокПриложения(ЗаголовокПриложения)");
#КонецЕсли
	КонецПопытки;
	
КонецПроцедуры 
