﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ОбновитьПараметрыНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	РасширениеПодключено = ПодключитьРасширениеРаботыСФайлами();
	Если НЕ РасширениеПодключено Тогда
		ФайловыеФункцииСлужебныйКлиент.ПредупредитьОНеобходимостиРасширенияРаботыСФайлами();
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	ОбновитьПараметрыНаКлиенте();
	ИмяКаталогаПрежнееЗначение = РабочийКаталогПользователя;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ВРег(ИсточникВыбора.ИмяФормы) = ВРег("Справочник.Файлы.Форма.СписокФайловВЛокальномКэшеФайлов") Тогда
		
		РабочийКаталогПользователяВФорме = РабочийКаталогПользователя;
		ОбновитьПараметры();
		РабочийКаталогПользователя = РабочийКаталогПользователяВФорме;
		
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура РабочийКаталогПользователяНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если НЕ ПодключитьРасширениеРаботыСФайлами() Тогда
		Возврат;
	КонецЕсли;
	
	// выбираем другой путь к рабочему каталогу
	ИмяКаталога = РабочийКаталогПользователя;
	Заголовок = НСтр("ru = 'Выберите основной рабочий каталог'");
	Если Не РаботаСФайламиСлужебныйКлиент.ВыбратьПутьКРабочемуКаталогу(ИмяКаталога, Заголовок, Ложь) Тогда
		Возврат;
	КонецЕсли;
	
	РабочийКаталогПользователя = ИмяКаталога;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ОбновитьВыполнить()
	ОбновитьПараметры();
КонецПроцедуры

&НаКлиенте
Процедура СписокФайловВыполнить()
	ОткрытьФорму("Справочник.Файлы.Форма.СписокФайловВЛокальномКэшеФайлов", , ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура СохранитьВыполнить()
	
	Если ИмяКаталогаПрежнееЗначение <> РабочийКаталогПользователя Тогда
		
#Если Не ВебКлиент Тогда
		
		Если НЕ РаботаСФайламиСлужебныйКлиент.ПеренестиСодержимоеРабочегоКаталога(
		          ИмяКаталогаПрежнееЗначение, РабочийКаталогПользователя) Тогда
			
			Возврат;
		КонецЕсли;
		
#КонецЕсли
		
	КонецЕсли;
	
	МассивСтруктур = Новый Массив;
	
	Элемент = Новый Структура;
	Элемент.Вставить("Объект",    "ЛокальныйКэшФайлов");
	Элемент.Вставить("Настройка", "ПутьКЛокальномуКэшуФайлов");
	Элемент.Вставить("Значение",  РабочийКаталогПользователя);
	МассивСтруктур.Добавить(Элемент);
	
	Элемент = Новый Структура;
	Элемент.Вставить("Объект", "ЛокальныйКэшФайлов");
	Элемент.Вставить("Настройка", "МаксимальныйРазмерЛокальногоКэшаФайлов");
	Элемент.Вставить("Значение", МаксимальныйРазмерЛокальногоКэшаФайлов * 1048576);
	МассивСтруктур.Добавить(Элемент);
	
	Элемент = Новый Структура;
	Элемент.Вставить("Объект", "ЛокальныйКэшФайлов");
	Элемент.Вставить("Настройка", "УдалятьФайлИзЛокальногоКэшаФайловПриЗавершенииРедактирования");
	Элемент.Вставить("Значение", УдалятьФайлИзЛокальногоКэшаФайловПриЗавершенииРедактирования);
	МассивСтруктур.Добавить(Элемент);
	
	Элемент = Новый Структура;
	Элемент.Вставить("Объект", "ЛокальныйКэшФайлов");
	Элемент.Вставить("Настройка", "ПодтверждатьПриУдаленииИзЛокальногоКэшаФайлов");
	Элемент.Вставить("Значение", ПодтверждатьПриУдаленииИзЛокальногоКэшаФайлов);
	МассивСтруктур.Добавить(Элемент);
	
	ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекСохранитьМассивИОбновитьПовторноИспользуемыеЗначения(МассивСтруктур);
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьЛокальныйКэшФайлов(Команда)

#Если НЕ ВебКлиент Тогда
	
	ТекстВопроса =
		НСтр("ru = 'Из основного рабочего каталога будут удалены все файлы,
		           |кроме занятых вами для редактирования.
		           |
		           |Продолжить?'");
	
	Ответ = Вопрос(ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	Если Ответ = КодВозвратаДиалога.Нет Тогда
		Возврат;
	КонецЕсли;
	
	Состояние(НСтр("ru = 'Выполняется очистка основного рабочего каталога...
	                     |Пожалуйста, подождите.'"));
	
	ИмяКаталога = ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекЗагрузить(
		"ЛокальныйКэшФайлов", "ПутьКЛокальномуКэшуФайлов");
	
	МассивФайлов = НайтиФайлы(ИмяКаталога, "*.*");
	
	РазмерФайловВРабочемКаталоге = 0;
	КоличествоСуммарное = 0;
	
	ФайловыеФункцииСлужебныйКлиент.ОбходФайловРазмер(
		ИмяКаталога, МассивФайлов, РазмерФайловВРабочемКаталоге, КоличествоСуммарное);
	
	// ОчищатьВсе = Истина.
	РаботаСФайламиСлужебныйКлиент.ОчиститьРабочийКаталог(РазмерФайловВРабочемКаталоге, 0, Истина);
	
	РазмерФайловВРабочемКаталоге = РазмерФайловВРабочемКаталоге / 1048576;
	
	РабочийКаталогПользователяВФорме = РабочийКаталогПользователя;
	ОбновитьПараметры();
	РабочийКаталогПользователя = РабочийКаталогПользователяВФорме;
	
	Состояние(НСтр("ru = 'Очистка основного рабочего каталога успешно завершена.'"));
	
#КонецЕсли

КонецПроцедуры

&НаКлиенте
Процедура ПутьКРабочемуКаталогуПоУмолчанию(Команда)
	
	РабочийКаталогПользователяВременный =
		ФайловыеФункцииСлужебныйКлиент.ВыбратьПутьККаталогуДанныхПользователя();
	
	Если РабочийКаталогПользователя = РабочийКаталогПользователяВременный Тогда
		Возврат;
	КонецЕсли;
	
	РабочийКаталогПользователя = РабочийКаталогПользователяВременный;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Процедура ОбновитьПараметрыНаСервере()
	
	УдалятьФайлИзЛокальногоКэшаФайловПриЗавершенииРедактирования = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("ЛокальныйКэшФайлов", "УдалятьФайлИзЛокальногоКэшаФайловПриЗавершенииРедактирования");
	Если УдалятьФайлИзЛокальногоКэшаФайловПриЗавершенииРедактирования = Неопределено Тогда
		УдалятьФайлИзЛокальногоКэшаФайловПриЗавершенииРедактирования = Ложь;
	КонецЕсли;
	
	ПодтверждатьПриУдаленииИзЛокальногоКэшаФайлов = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("ЛокальныйКэшФайлов", "ПодтверждатьПриУдаленииИзЛокальногоКэшаФайлов");
	Если ПодтверждатьПриУдаленииИзЛокальногоКэшаФайлов = Неопределено Тогда
		ПодтверждатьПриУдаленииИзЛокальногоКэшаФайлов = Ложь;
	КонецЕсли;
	
	МаксРазмер = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("ЛокальныйКэшФайлов", "МаксимальныйРазмерЛокальногоКэшаФайлов");
	Если МаксРазмер = Неопределено Тогда
		МаксРазмер = 100*1024*1024; // 100 мб		
		ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("ЛокальныйКэшФайлов", "МаксимальныйРазмерЛокальногоКэшаФайлов", МаксРазмер);
	КонецЕсли;
	МаксимальныйРазмерЛокальногоКэшаФайлов = МаксРазмер / 1048576;

КонецПроцедуры

&НаКлиенте
Процедура ОбновитьПараметрыНаКлиенте()
	
	РабочийКаталогПользователя = ФайловыеФункцииСлужебныйКлиент.РабочийКаталогПользователя();
	
#Если НЕ ВебКлиент Тогда
	
	МассивФайлов = НайтиФайлы(РабочийКаталогПользователя, "*.*");
	РазмерФайловВРабочемКаталоге = 0;
	КоличествоСуммарное = 0;
	
	ФайловыеФункцииСлужебныйКлиент.ОбходФайловРазмер(
		РабочийКаталогПользователя,
		МассивФайлов,
		РазмерФайловВРабочемКаталоге,
		КоличествоСуммарное); 
	
	РазмерФайловВРабочемКаталоге = РазмерФайловВРабочемКаталоге / 1048576;
	
#КонецЕсли

КонецПроцедуры

&НаКлиенте
Процедура ОбновитьПараметры()
	ОбновитьПараметрыНаСервере();
	ОбновитьПараметрыНаКлиенте();
КонецПроцедуры

