﻿////////////////////////////////////////////////////////////////////////////////
// Варианты отчетов - Форма отчета (переопределяемый)
// 
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// В данной процедуре следует описать дополнительные зависимости объектов метаданных
//   конфигурации, которые будут использоваться для связи настроек отчетов.
//
// Параметры:
//   СвязиОбъектовМетаданных (ТаблицаЗначений)
//       |- ПодчиненныйРеквизит (Строка) Имя реквизита подчиненного объекта метаданных
//       |- ПодчиненныйТип      (Тип)    Тип подчиненного объекта метаданных
//       |- ВедущийТип          (Тип)    Тип ведущего объекта метаданных
//
Процедура ДополнитьСвязиОбъектовМетаданных(СвязиОбъектовМетаданных) Экспорт
	
	
	
КонецПроцедуры

// Вызывается в одноименном обработчике формы отчета после выполнения кода формы.
//
// Параметры:
//   ЭтаФорма (УправляемаяФорма)
//   Остальные параметры передаются из параметров обработчика "как есть",
//       см. события для "УправляемаяФорма" в справке.
//
Процедура ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка) Экспорт
	
КонецПроцедуры

// Вызывается в обработчике "ПриЗагрузкеВариантаНаСервере" формы отчета до выполнения кода формы.
//
// Параметры:
//   ЭтаФорма (УправляемаяФорма)
//   Остальные параметры передаются из параметров обработчика "как есть",
//       см. события для "Расширение управляемой формы для отчета" в справке.
//
Процедура ПередЗагрузкойВариантаНаСервере(ЭтаФорма, НовыеНастройкиКД) Экспорт
	
КонецПроцедуры

// Вызывается в одноименном обработчике формы отчета после выполнения кода формы.
//
// Параметры:
//   ЭтаФорма (УправляемаяФорма)
//   Остальные параметры передаются из параметров обработчика "как есть",
//       см. события для "Расширение управляемой формы для отчета" в справке.
//
Процедура ПриЗагрузкеВариантаНаСервере(ЭтаФорма, НовыеНастройкиКД) Экспорт
	
КонецПроцедуры

// Вызывается в обработчике "ПриЗагрузкеПользовательскихНастроекНаСервере"
//   формы отчета до выполнения кода формы.
//
// Параметры:
//   ЭтаФорма (УправляемаяФорма)
//   Остальные параметры передаются из параметров обработчика "как есть",
//       см. события для "Расширение управляемой формы для отчета" в справке.
//
Процедура ПередЗагрузкойПользовательскихНастроекНаСервере(ЭтаФорма, НовыеПользовательскиеНастройкиКД) Экспорт
	
КонецПроцедуры

// Вызывается в одноименном обработчике формы отчета после выполнения кода формы.
//
// Параметры:
//   ЭтаФорма (УправляемаяФорма)
//   Остальные параметры передаются из параметров обработчика "как есть",
//       см. события для "Расширение управляемой формы для отчета" в справке.
//
Процедура ПриЗагрузкеПользовательскихНастроекНаСервере(ЭтаФорма, НовыеПользовательскиеНастройкиКД) Экспорт
	
КонецПроцедуры

// Вызывается после перезаполнения панели быстрых настроек.
//
// Параметры:
//   ЭтаФорма (УправляемаяФорма)
//
Процедура ПослеЗаполненияПанелиБыстрыхНастроек(ЭтаФорма) Экспорт
	
КонецПроцедуры

// Обработчик контекстного вызова сервера.
//
// Параметры:
//   ЭтаФорма  (УправляемаяФорма)
//   Ключ      (Строка)    Ключ операции, которую необходимо выполнить в контекстном вызове.
//   Параметры (Структура) Параметры вызова сервера.
//   Результат (Структура) Результат работы сервера, возвращается на клиент.
//
Процедура КонтекстныйВызовСервера(ЭтаФорма, Ключ, Параметры, Результат) Экспорт
	
КонецПроцедуры

