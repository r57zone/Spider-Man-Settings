[![EN](https://user-images.githubusercontent.com/9499881/33184537-7be87e86-d096-11e7-89bb-f3286f752bc6.png)](https://github.com/r57zone/Spider-Man-Settings/) 
[![RU](https://user-images.githubusercontent.com/9499881/27683795-5b0fbac6-5cd8-11e7-929c-057833e01fb1.png)](https://github.com/r57zone/Spider-Man-Settings/blob/master/README.RU.md)

# Spider Man Settings
Утилита для настройки Spider-Man (2001), позволяющая изменять разрешение экрана, соотношение сторон, глубину цвета и яркость, а также активировать дополнительные возможности, включая поддержку Xbox-контроллеров, вибрацию, ограничение частоты кадров и другие функции.

Поддерживаются широкоформатные разрешения, включая `16:9`, `21:9` и `32:9`. Совместимость проверена с английской версией игры, а также с русскими переводами от 7Волк и Фаргус.

# Возможности и изменения
- **Широкоформатные разрешения.** Исправлено отсечение объектов за пределами экрана (culling) и масштабирование объектов с проекцией, характерной для версии игры на PS1, например щупалец Венома.
- **Улучшения HUD.** Добавлены два варианта интерфейса: улучшенный, с оптимальным расположением элементов, и классический, приближенный к оригинальному дизайну игры.
- **Автозагрузка сохранения.** При запуске игры автоматически загружается первое сохранение.
- **Улучшенная поддержка контроллеров.** Добавлена трансляция вызовов из DInput в XInput с помощью [DInputAdvance](https://github.com/r57zone/DInputAdvance), включая поддержку вибрации. Реализована вибрация при получении урона. Исправлена работа кнопки подтверждения в меню и управление при просмотре видеороликов.
- **Исправление звука.** Устранено заикание фоновой музыки на уровне со Скорпионом.
- **Редактор сохранения.** Добавлен редактор, позволяющий менять текущий уровень, разблокировать костюмы и выбирать активный костюм.

### Широкоформатные разрешения
| 16:9 | 21:9 | 32:9 |
|:---:|:---:|:---:|
| [![Игра 16:9](https://github.com/user-attachments/assets/c08af20f-3da0-4013-80f6-e14e97a13c12)](https://github.com/user-attachments/assets/fa6d5cfe-5554-4bba-990a-691bc40145d6) | [![Игра 21:9](https://github.com/user-attachments/assets/f41dfa3e-2163-4c84-b9f7-dc568be5cb5c)](https://github.com/user-attachments/assets/d03ef5c5-7ea1-4c88-b55c-0acc1b1760af) | [![Игра 32:9](https://github.com/user-attachments/assets/e8c77e49-2ff0-4e32-aa81-235a1c626fab)](https://github.com/user-attachments/assets/08a1a7c4-13c4-4dd2-a53f-412a3c61fdde) |
| [![Меню 16:9](https://github.com/user-attachments/assets/c6635254-0cc3-45fb-b80e-bcb8f9ac692e)](https://github.com/user-attachments/assets/07426e3c-46b7-48da-99e3-6d02212d6164) | [![Меню 21:9](https://github.com/user-attachments/assets/c699b0cf-2b28-4364-a785-3a53e4653fa0)](https://github.com/user-attachments/assets/d4301a3b-862f-4f48-9863-63ae105fc601) | [![Меню 32:9](https://github.com/user-attachments/assets/b7ad696a-8364-45b0-8726-2e3f2a0149bf)](https://github.com/user-attachments/assets/c2c12629-3a9b-4217-b3e5-f4d06bd178d5) |

### Варианты интерфейса
| Общий | Улучшенный | Классический |
|:---:|:---:|:---:|
| [![Общий интерфейс](https://github.com/user-attachments/assets/5d6ccd78-2b63-4166-9450-a5ed255934a7)](https://github.com/user-attachments/assets/b98f1ae0-84af-46c8-9b68-3d1606d52bbb) | [![Улучшенный интерфейс](https://github.com/user-attachments/assets/29077be2-a3c4-4a18-8689-16c51b5e83f0)](https://github.com/user-attachments/assets/8f23720c-d05a-4817-9ac0-9cb6bc490581) | [![Классический интерфейс](https://github.com/user-attachments/assets/1f1bc10c-b588-4030-8a12-85954bc87e2a)](https://github.com/user-attachments/assets/5074b9ac-f8fd-41d8-b267-2db1471e3e81) |
| [![Общий интерфейс](https://github.com/user-attachments/assets/3e66aec8-d756-411b-a1b9-c7c1ef1fff79)](https://github.com/user-attachments/assets/6ad26cde-a658-44a9-ab13-3f2a505349fb) | [![Улучшенный интерфейс](https://github.com/user-attachments/assets/0db37810-9b18-4e81-bae9-a6e3bc168fea)](https://github.com/user-attachments/assets/eea768da-c3e7-4b45-9b5a-ef642d38ee1c) | [![Классический интерфейс](https://github.com/user-attachments/assets/48df8e98-02fb-4d5e-9a43-f507198fbc1a)](https://github.com/user-attachments/assets/4810d11c-9ff2-4e5a-a317-1d1c2fcfb7bf) |
| [![Общий интерфейс](https://github.com/user-attachments/assets/febe4dc3-cc74-429c-b5c2-b21e78f2d685)](https://github.com/user-attachments/assets/36dde3ce-3d7e-45aa-ac06-418d27f34b81) | [![Улучшенный интерфейс](https://github.com/user-attachments/assets/f8d346ff-46cd-4cb8-92f8-99c5bfadae97)](https://github.com/user-attachments/assets/2d7c9ca9-af3c-4981-af4f-5c2b59fd94f4) | [![Классический интерфейс](https://github.com/user-attachments/assets/8fb1c81f-b0ee-4159-9036-5dd5d8c26d74)](https://github.com/user-attachments/assets/c48f85e4-fae5-4df4-b85d-94c34925d118) |

### Утилита
[![Spider-Man Settings](https://github.com/user-attachments/assets/a122cb0d-bd82-42ad-a7d4-c84583a2b4ce)](https://github.com/user-attachments/assets/384acded-40b8-4e30-bd80-521721b0154f) [![Spider-Man Settings](https://github.com/user-attachments/assets/b5cccbe9-32b6-4dab-9576-9c6f49f049e0)](https://github.com/user-attachments/assets/bc4de126-8888-41bc-8819-2cb730a9387d)

## Установка
1. Закройте игру, если она открыта.
2. Загрузите [архив](https://github.com/r57zone/Spider-Man-Settings/releases) и распакуйте его целиком в папку с игрой.
3. Запустите приложение `Spider-Man Settings` и выберите нужные параметры.
4. Нажмите кнопку `Применить` и приложение пропатчит нужные файлы.
5. В свойствах игры измените `Режим совместимости` на `Windows XP Пакет обновления 2` для устранения проблем со звуком.

## Загрузка
>Версия для XP, Vista, 7, 8.1, 10, 11.

**[Загрузить](https://github.com/r57zone/Spider-Man-Settings/releases)**

## Известные проблемы
| Уровень | Скриншот | Описание | Решение |
|:---:|:---:|:---|:---|
| Гонка к редакции Bugle | [![Гонка к редакции Bugle](https://github.com/user-attachments/assets/ad9c6cb4-1c0d-4081-843a-2c2e8dfb0e52)](https://github.com/user-attachments/assets/131e50cf-7fa0-4c6a-a6ae-052c47615992) | При пропуске катсцены Скорпион может сразу оказаться в редакции Daily Bugle, что приводит к провалу миссии. | Не пропускайте катсцену. |
| Взобраться по балкам | [![Взобраться по балкам](https://github.com/user-attachments/assets/d4b17195-9dfc-4825-a67a-658c1bfce156)](https://github.com/user-attachments/assets/4118bb99-29e1-4c60-a8b6-c8eeb85aa806) | Человек-паук должен выстрелить паутиной и прыгнуть вперёд с ящика, но иногда вместо этого падает. | Повторно нажмите кнопку выстрела паутиной или ограничьте частоту кадров до 24 FPS на время этого этапа. |
| Поймать Венома | [![Поймать Венома](https://github.com/user-attachments/assets/60032c4f-d122-49ef-875a-42dfc00146d5)](https://github.com/user-attachments/assets/9d17a192-393f-409c-8f59-dbb23437e104) | Человек-паук должен запрыгнуть на стену, но иногда не делает этого. | Попробуйте действовать быстрее или ограничьте частоту кадров до 24 FPS на время этого этапа. |
| Спайди против Мистерио! | [![Заголовок](https://github.com/user-attachments/assets/b2945ede-2254-495b-9a44-2eca81f9d638)](https://github.com/user-attachments/assets/12e41003-26e5-4d81-8565-ed140029adcb) | На втором этапе битвы Мистерио стреляет лазерами слишком быстро, затрудняя уклонение. | На среднем уровне сложности ограничьте частоту кадров до 24 FPS на время этого этапа. |

## Благодарности
- [Hemanshu Shekhar](https://community.pcgamingwiki.com/profile/9470-hemanshu-shekhar/) - за найденные адреса в памяти игры для изменения FOV и соотношения сторон.
- [GTRemyLeceau (GTTeancum)](https://github.com/GTTeancum/SpideyPS1recomp) - за рекомпиляцию версии игры для PS1 и широкоформатные улучшения.
- [Elisha Riedlinger (elishacloud)](https://github.com/elishacloud) - за DxWrapper.
- [Jose Silva (krystalgamer)](https://github.com/krystalgamer/spidey-tools) - за утилиту для изменения сохранений.
- [Claude AI](https://claude.ai) - за помощь в остальных улучшениях.

## Обратная связь
`r57zone@gmail.com`