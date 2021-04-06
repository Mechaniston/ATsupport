﻿
&НаКлиенте
Процедура ЦеныПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	Если Объект.Цены.НайтиСтроки(Новый Структура("Номенклатура", Элемент.ТекущиеДанные.Номенклатура)).Количество() > 1 Тогда
		
		Объект.Цены.Удалить(Элемент.ТекущиеДанные);
		ПоказатьПредупреждение(, "Номенклатура не может повторяться!", 5);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ОбновитьОтборПоВидуДоговора();
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьОтборПоВидуДоговора()
	
	МассивВидовДоговоров = Новый Массив;
	МассивВидовДоговоров.Добавить(Объект.Договор.ВидДоговора);
	МассивВидовДоговоров.Добавить(Справочники.ВидыДоговоров_ат.ПустаяСсылка());
	ВидыДоговора.ЗагрузитьЗначения(МассивВидовДоговоров);
	НоваяСвязь = Новый СвязьПараметраВыбора("Отбор.ВидДоговора", "ВидыДоговора");
	НовыйМассив = Новый Массив();
	НовыйМассив.Добавить(НоваяСвязь);
	НовыеСвязи = Новый ФиксированныйМассив(НовыйМассив);
	Элементы.ЦеныНоменклатура.СвязиПараметровВыбора = НовыеСвязи;
	
КонецПроцедуры

&НаКлиенте
Процедура ДоговорПриИзменении(Элемент)
	
	ОбновитьОтборПоВидуДоговора();
	
КонецПроцедуры

&НаКлиенте
Процедура ПоставщикПриИзменении(Элемент)
	
	ОбновитьОтборПоВидуДоговора();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	УправляемыеФормы_Клиент_ат.ПередЗаписью(ЭтаФорма, Отказ, ПараметрыЗаписи);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	УправляемыеФормы_Клиент_ат.ПослеЗаписи(ЭтаФорма, ПараметрыЗаписи);
	
КонецПроцедуры
