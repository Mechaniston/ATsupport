﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	КаталогДляСохраненияДанныхПечати = УправлениеПечатью.ПолучитьЛокальныйКаталогФайловПечати();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура ПутьККаталогуНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Если ПодключитьРасширениеРаботыСФайлами() Тогда
		ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.ВыборКаталога);
		ДиалогОткрытияФайла.ПолноеИмяФайла = "";
		ДиалогОткрытияФайла.Каталог = КаталогДляСохраненияДанныхПечати;
		ДиалогОткрытияФайла.МножественныйВыбор = Ложь;
		ДиалогОткрытияФайла.Заголовок = НСтр("ru = 'Выберите путь к каталогу для файлов печати.'");
		Если ДиалогОткрытияФайла.Выбрать() Тогда
			КаталогДляСохраненияДанныхПечати = ДиалогОткрытияФайла.Каталог + "\";
		КонецЕсли;
	Иначе
		Предупреждение(НСтр("ru = 'Для выбора каталога необходимо установить расширение для работы с файлами в Веб-клиенте.'"));
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ОК(Команда)
	
	УправлениеПечатьюВызовСервера.СохранитьЛокальныйКаталогФайловПечати(КаталогДляСохраненияДанныхПечати);
	ОповеститьОВыборе(КаталогДляСохраненияДанныхПечати);
	
КонецПроцедуры
