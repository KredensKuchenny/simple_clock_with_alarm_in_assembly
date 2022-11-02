# Simple clock with alarm in assembly
<b>Napisz program, który będzie realizował funkcję zegara z alarmem:</b>
  - Format wyświetlania hh:mm:ss
  - Ustawianie godziny przy uruchomieniu programu:
    - Wprowadzamy: Godzinę (0-23)
    - Minuty (0-59)
    - Sekundy (0-59)
  - Ustawianie alarmu przy uruchomieniu programu:
    - Wprowadzamy: Godzinę (0-23)
    - Minuty (0-59)

<b>Działanie zegara:</b>
  - przy uruchomieniu ustawienie godziny, minuty i sekundy, a następnie godziny i minuty alarmu
  - wprowadzane liczby są wyświetlane cyfra po cyfrze
  - po ustawieniu alarmu zegar zaczyna działać - wyświetlana jest godzina, minuta i sekunda w formacie hh:mm:ss, z każdą odliczoną sekundą ekran LCD aktualizuje się
  - gdy godzina i minuta zegara osiągnie wartość zadeklarowaną dla alarmu, dioda i/lub brzęczek są uruchamiane na zdefiniowany w kodzie czas (np. 2 sekundy)  lub do odwołania za pomocą przycisku "enter" ("F" heksadecymalnie wprowadzane z klawiatury)
