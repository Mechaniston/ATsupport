﻿
Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	ПараметрСервер 					= КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Сервер"));
	ПараметрСервер.Значение		= Сервер;
	ПараметрСервер.Использование	= Истина;

	ПараметрНачПер 					= КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ДатаНачала"));
	ПараметрНачПер.Значение		= ДатаНачала;
	ПараметрНачПер.Использование	= Истина;

	ПараметрКонПер					= КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ДатаКонца"));
	ПараметрКонПер.Значение		= ДатаКонца;
	ПараметрКонПер.Использование	= Истина;

	//ТипыРесурсов = новый СписокЗначений;
	//ТипыРесурсов.Добавить(Перечисления.ТипыРесурсовWMI_ат.CPU_proc);
	//ТипыРесурсов.Добавить(Перечисления.ТипыРесурсовWMI_ат.RAM_proc);
	//ТипыРесурсов.Добавить(Перечисления.ТипыРесурсовWMI_ат.HDD_proc);

	//ПараметрТипРес1						= КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ТипыРесурсов"));
	//ПараметрТипРес1.Значение			= ТипыРесурсов;
	//ПараметрТипРес1.Использование	= Истина;
		
	ЗаполнениеГрафика(Сервер, CPU,Перечисления.ТипыРесурсовWMI_ат.CPU_proc,	ДатаНачала, ДатаКонца);
	ЗаполнениеГрафика(Сервер, RAM,Перечисления.ТипыРесурсовWMI_ат.RAM_proc,	ДатаНачала, ДатаКонца);
	ЗаполнениеГрафика(Сервер, HDD,Перечисления.ТипыРесурсовWMI_ат.HDD_proc,	ДатаНачала, ДатаКонца);
	
КонецПроцедуры


Процедура ЗаполнениеГрафика(Сервер, График, ТипРесурса, НачалоПериода, КонецПериода, ПериодДняИНочи	= 0)

График	= Новый ТабличныйДокумент;


// НачалоПериода	= ПоследниеДанныеАктуальныНа -УсредненныеЗначенияЗа*60*60;
// КонецПериода	= ПоследниеДанныеАктуальныНа;
// ТипРесурса1	= Перечисления.ТипыРесурсовWMI_ат.CPU_proc;
// ТипРесурса2	= Перечисления.ТипыРесурсовWMI_ат.RAM_proc;
// ТипРесурса3	= Перечисления.ТипыРесурсовWMI_ат.HDD_proc;


//Получаем схему из макета
//СхемаКомпоновкиДанных = Справочники.Серверы_ат.ПолучитьМакет("Макет");
//СхемаКомпоновкиДанных = Отчеты.ОбщийОтчетОПроизводительностиСервера_ат.ПолучитьМакет("ОсновнаяСхемаКомпоновкиДанных");


//СхемаКомпоновкиДанных = Отчет.КомпоновщикНастроек.П 
//ТипРесурса = Новый СписокЗначений;
//ТипРесурса.Добавить(ТипРесурса1);
//ТипРесурса.Добавить(ТипРесурса2);
//ТипРесурса.Добавить(ТипРесурса3);

СхемаКомпоновкиДанных = Отчеты.ПодробнаяСтатисткаWMIПоСерверам_ат.ПолучитьМакет("ОсновнаяСхемаКомпоновкиДанных");

 КНКД = Новый КомпоновщикНастроекКомпоновкиДанных;
 КНКД.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(СхемаКомпоновкиДанных));
 КНКД.ЗагрузитьНастройки(СхемаКомпоновкиДанных.НастройкиПоУмолчанию);
 КНКД.Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("Сервер", 			Сервер);
 //КНКД.Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("ТипыРесурсов", 	ТипРесурса);
 //КНКД.Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("НачалоПериода",	НачалоПериода);
 //КНКД.Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("КонецПериода",		КонецПериода);
 //КНКД.Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("ДатаНачала",	НачалоПериода);
 //КНКД.Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("ДатаКонца",	КонецПериода);
 КНКД.Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("НачалоПериода",		НачалоПериода);
 КНКД.Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("КонецПериода",		КонецПериода);
 КНКД.Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("ПериодДняИНочи",	ПериодДняИНочи);
 //КНКД.Настройки.ПараметрыВывода.ДоступныеПараметры

 // Компоновка макета
 
    КМКД = Новый КомпоновщикМакетаКомпоновкиДанных;
    Настройки = КНКД.Настройки;	
    МакетКомпоновкиДанных = КМКД.Выполнить(СхемаКомпоновкиДанных, Настройки,,, Тип("ГенераторМакетаКомпоновкиДанных"));

	   // Инициализация процессора компоновки
 
    ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
    ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновкиДанных);
    
    ПроцессорВывода = новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
    ПроцессорВывода.УстановитьДокумент(График);
    ПроцессорВывода.НачатьВывод();

    Пока Истина Цикл
        ЭлементРезультата = ПроцессорКомпоновкиДанных.Следующий();
        Если ЭлементРезультата= Неопределено Тогда
            Прервать;
        Иначе
            ПроцессорВывода.ВывестиЭлемент(ЭлементРезультата);
        КонецЕсли;
    КонецЦикла;
	ПроцессорВывода.ЗакончитьВывод();
	//График.Рисунки[0].Ширина = 100;	
	//График.Рисунки[0].Высота  = 50;

КонецПроцедуры
