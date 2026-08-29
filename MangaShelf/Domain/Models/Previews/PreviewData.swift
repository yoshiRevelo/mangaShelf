//
//  PreviewData.swift
//  MangaShelf
//
//  Created by Josimar Revelo on 22/08/26.
//

import Foundation

// Datos de ejemplo para las Previews de SwiftUI y para los mocks de desarrollo/tests.
// Son mangas reales de la API (Monster y Berserk), para que los previews se vean
// como se va a ver la app de verdad.
nonisolated extension Manga {

    private static func isoDate(_ string: String) -> Date {
        ISO8601DateFormatter().date(from: string)!
    }

    static let monster = Manga(
        id: 1,
        title: "Monster",
        titleEnglish: "Monster",
        titleJapanese: "MONSTER",
        synopsis: """
        Kenzou Tenma, a renowned Japanese neurosurgeon working in post-war Germany, faces a difficult choice: to operate on Johan Liebert, an orphan boy on the verge of death, or on the mayor of Düsseldorf. In the end, Tenma decides to gamble his reputation by saving Johan, effectively leaving the mayor for dead.

        As a consequence of his actions, hospital director Heinemann strips Tenma of his position, and Heinemann's daughter Eva breaks off their engagement. Disgraced and shunned by his colleagues, Tenma loses all hope of a successful career—that is, until the mysterious killing of Heinemann gives him another chance.

        Nine years later, Tenma is the head of the surgical department and close to becoming the director himself. Although all seems well for him at first, he soon becomes entangled in a chain of gruesome murders that have taken place throughout Germany. The culprit is a monster—the same one that Tenma saved on that fateful day nine years ago.

        [Written by MAL Rewrite]
        """,
        background: "Monster won the Grand Prize at the 3rd annual Tezuka Osamu Cultural Prize in 1999, as well as the 46th Shogakukan Manga Award in the General category in 2000. The series was published in English by VIZ Media under the VIZ Signature imprint from February 21, 2006 to December 16, 2008, and again in 2-in-1 omnibuses (subtitled The Perfect Edition) from July 15, 2014 to July 19, 2016. The manga was also published in Brazilian Portuguese by Panini Comics/Planet Manga from June 2012 to April 2015, in Polish by Hanami from March 2014 to February 2017, in Spain by Planeta Cómic from June 16, 2009 to September 21, 2010, and in Argentina by LARP Editores.",
        status: "finished",
        score: 9.15,
        chapters: 162,
        volumes: 18,
        startDate: isoDate("1994-12-05T00:00:00Z"),
        endDate: isoDate("2001-12-20T00:00:00Z"),
        mainPicture: URL(string: "https://cdn.myanimelist.net/images/manga/3/258224l.jpg"),
        url: URL(string: "https://myanimelist.net/manga/1/Monster"),
        authors: [
            Author(id: UUID(uuidString: "54BE174C-2FE9-42C8-A842-85D291A6AEDD")!, firstName: "Naoki", lastName: "Urasawa", role: "Story & Art")
        ],
        genres: [
            Genre(id: UUID(uuidString: "4C13067F-96FF-4F14-A1C0-B33215F24E0B")!, genre: "Award Winning"),
            Genre(id: UUID(uuidString: "4312867C-1359-494A-AC46-BADFD2E1D4CD")!, genre: "Drama"),
            Genre(id: UUID(uuidString: "97C8609D-856C-419E-A4ED-E13A5C292663")!, genre: "Mystery")
        ],
        themes: [
            Theme(id: UUID(uuidString: "4394C99F-615B-494A-929E-356A342A95B8")!, theme: "Psychological"),
            Theme(id: UUID(uuidString: "840867E7-6C60-49CE-8C47-A99AA71A2113")!, theme: "Adult Cast")
        ],
        demographics: [.seinen]
    )

    static let berserk = Manga(
        id: 2,
        title: "Berserk",
        titleEnglish: "Berserk",
        titleJapanese: "ベルセルク",
        synopsis: """
        Guts, a former mercenary now known as the "Black Swordsman," is out for revenge. After a tumultuous childhood, he finally finds someone he respects and believes he can trust, only to have everything fall apart when this person takes away everything important to Guts for the purpose of fulfilling his own desires. Now marked for death, Guts becomes condemned to a fate in which he is relentlessly pursued by demonic beings.

        Setting out on a dreadful quest riddled with misfortune, Guts, armed with a massive sword and monstrous strength, will let nothing stop him, not even death itself, until he is finally able to take the head of the one who stripped him—and his loved one—of their humanity.

        [Written by MAL Rewrite]

        Included one-shot:
        Volume 14: Berserk: The Prototype
        """,
        background: "Berserk won the Award for Excellence at the sixth installment of Tezuka Osamu Cultural Prize in 2002. The series has over 50 million copies in print worldwide and has been published in English by Dark Horse since November 4, 2003. It is also published in Italy, Germany, Spain, France, Brazil, South Korea, Hong Kong, Taiwan, Thailand, Poland, México and Turkey. In May 2021, the author Kentaro Miura suddenly died at the age of 54. Chapter 364 of Berserk was published posthumously on September 10, 2021. Miura would often share details about the series' story with his childhood friend and fellow mangaka Kouji Mori. Berserk resumed on June 24, 2022, with Studio Gaga handling the art and Kouji Mori's supervision.",
        status: "currently_publishing",
        score: 9.47,
        chapters: nil,
        volumes: nil,
        startDate: isoDate("1989-08-25T00:00:00Z"),
        endDate: nil,
        mainPicture: URL(string: "https://cdn.myanimelist.net/images/manga/1/157897l.jpg"),
        url: URL(string: "https://myanimelist.net/manga/2/Berserk"),
        authors: [
            Author(id: UUID(uuidString: "6F0B6948-08C4-4761-8BE1-192E68AB0A2F")!, firstName: "Kentarou", lastName: "Miura", role: "Story & Art"),
            Author(id: UUID(uuidString: "0304C4E9-2D89-463A-8FDD-EEAB5B9D57B3")!, firstName: "", lastName: "Studio Gaga", role: "Art")
        ],
        genres: [
            Genre(id: UUID(uuidString: "72C8E862-334F-4F00-B8EC-E1E4125BB7CD")!, genre: "Action"),
            Genre(id: UUID(uuidString: "BE70E289-D414-46A9-8F15-928EAFBC5A32")!, genre: "Adventure"),
            Genre(id: UUID(uuidString: "4C13067F-96FF-4F14-A1C0-B33215F24E0B")!, genre: "Award Winning"),
            Genre(id: UUID(uuidString: "4312867C-1359-494A-AC46-BADFD2E1D4CD")!, genre: "Drama"),
            Genre(id: UUID(uuidString: "B3E8D4B2-7EE4-49CD-8DB0-9897619B3F62")!, genre: "Fantasy"),
            Genre(id: UUID(uuidString: "3B6A9037-3F61-4483-AD8A-E43365C5C953")!, genre: "Horror"),
            Genre(id: UUID(uuidString: "AE80120B-6659-4C0E-AEB2-227EC25EC4AF")!, genre: "Supernatural")
        ],
        themes: [
            Theme(id: UUID(uuidString: "82728A80-0DBE-4B64-A295-A25555A4A4A5")!, theme: "Gore"),
            Theme(id: UUID(uuidString: "AD119CBB-2CCE-42FE-BD89-32D42C46462F")!, theme: "Military"),
            Theme(id: UUID(uuidString: "AD7A66B1-D066-4BC0-8AEE-7B97904F003A")!, theme: "Mythology"),
            Theme(id: UUID(uuidString: "4394C99F-615B-494A-929E-356A342A95B8")!, theme: "Psychological")
        ],
        demographics: [.seinen]
    )

    static let twentiethCenturyBoys = Manga(
        id: 3,
        title: "20th Century Boys",
        titleEnglish: "20th Century Boys",
        titleJapanese: "20世紀少年",
        synopsis: """
        As the 20th century approaches its end, people all over the world are anxious that the world is changing. And probably not for the better.

        Kenji Endo is a normal convenience store manager who's just trying to get by. But when he learns that one of his old friends going by the name "Donkey" has suddenly committed suicide, and that a new cult led by a figure known as "Friend" is becoming more notorious, Kenji starts to feel that something isn't right. With a few key clues left behind by his deceased friend, Kenji realizes that this cult is much more than he ever thought it would be—not only is this mysterious organization directly targeting him and his childhood friends, but the whole world also faces a grave danger that only the friends have the key to stop.

        Kenji's simple life of barely making ends meet is flipped upside down when he reunites with his childhood friends, and together they must figure out the truth of how their past is connected to the cult, as the turn of the century could mean the possible end of the world.

        [Written by MAL Rewrite]
        """,
        background: "20th Century Boys won the Kodansha Manga Award in the general category in 2001, an Excellence Prize at the Japan Media Arts Festival in 2002, and the Shogakukan Manga Award in the general category in 2003. The series' combined storyline won the Grand Prize at the 37th Japan Cartoonist Awards on May 9, 2008. VIZ Media published the series in English under the VIZ Signature imprint from February 17, 2009 to September 18, 2012. VIZ Media licensed the series in 2005; however, at Urasawa's request, it was rescheduled for release after Monster finished its English publication due to a change in art style over time. The series has also been published in Brazilian Portuguese by Panini Comics/Planet Manga since September 2012. The series was adapted into a trilogy of live-action films which released in Japan between August 30, 2008 and August 29, 2009.",
        status: "finished",
        score: 8.95,
        chapters: 249,
        volumes: 22,
        startDate: isoDate("1999-09-27T00:00:00Z"),
        endDate: isoDate("2006-04-24T00:00:00Z"),
        mainPicture: URL(string: "https://cdn.myanimelist.net/images/manga/5/260006l.jpg"),
        url: URL(string: "https://myanimelist.net/manga/3/20th_Century_Boys"),
        authors: [
            Author(id: UUID(uuidString: "54BE174C-2FE9-42C8-A842-85D291A6AEDD")!, firstName: "Naoki", lastName: "Urasawa", role: "Story & Art")
        ],
        genres: [
            Genre(id: UUID(uuidString: "4C13067F-96FF-4F14-A1C0-B33215F24E0B")!, genre: "Award Winning"),
            Genre(id: UUID(uuidString: "4312867C-1359-494A-AC46-BADFD2E1D4CD")!, genre: "Drama"),
            Genre(id: UUID(uuidString: "97C8609D-856C-419E-A4ED-E13A5C292663")!, genre: "Mystery"),
            Genre(id: UUID(uuidString: "2DEDC015-82DA-4EF4-B983-F0F58C8F689E")!, genre: "Sci-Fi")
        ],
        themes: [
            Theme(id: UUID(uuidString: "4394C99F-615B-494A-929E-356A342A95B8")!, theme: "Psychological"),
            Theme(id: UUID(uuidString: "3CF0EDA7-5856-40F7-A0CF-EC676B4A842C")!, theme: "Historical")
        ],
        demographics: [.seinen]
    )

    static let yokohamaKaidashiKikou = Manga(
        id: 4,
        title: "Yokohama Kaidashi Kikou",
        titleEnglish: "Yokohama Kaidashi Kikou",
        titleJapanese: "ヨコハマ買い出し紀行",
        synopsis: """
        In a post-apocalyptic world where an environmental disaster led to the eruption of Mt. Fuji and the inundation of Yokohama, the age of humans is in its twilight. Alpha Hatsuseno is an android and the namesake of a small cafe outside Yokohama. As her owner is away on a trip indefinitely, she has been left responsible for running the cafe. Although she rarely gets any customers, Alpha remains outgoing and cheerful.

        While Alpha awaits her owner's homecoming, she explores the vicinity with her scooter and camera. Throughout her journeys, she meets new people and other androids, making memories along the way.

        Yokohama Kaidashi Kikou is a beautiful, laid-back story centered around Alpha's daily activities, emphasizing the passing of time in everyday life.

        [Written by MAL Rewrite]
        """,
        background: "Three drama CDs were released in 2002. In all three, Alpha is voiced by Hekiru Shiina and Kokone by Akiko Nakagawa. Both of whom voiced the same characters in the two OVA series. A novel based on Yokohama Kaidashi Kikou called Yokohama Kaidashi Kikou Novel: Seeing, Walking, Being Glad, written by Teriha Katsuki, was published by Kodansha on 23 October 2008. Set long after the conclusion of the manga series, it tells the story of a boy robot named Omega and his search for the legendary Cafe Alpha. (Source: Wikipedia) In 2007, the series won the Seiun Award for Best Manga. Yokohama Kaidashi Kikou has been published in English by Seven Seas Entertainment as omnibus volumes since August 9, 2022.",
        status: "finished",
        score: 8.68,
        chapters: 142,
        volumes: 14,
        startDate: isoDate("1994-04-25T00:00:00Z"),
        endDate: isoDate("2006-02-25T00:00:00Z"),
        mainPicture: URL(string: "https://cdn.myanimelist.net/images/manga/1/171813l.jpg"),
        url: URL(string: "https://myanimelist.net/manga/4/Yokohama_Kaidashi_Kikou"),
        authors: [
            Author(id: UUID(uuidString: "EC4982FD-4793-4A1A-B956-D2E57895BB57")!, firstName: "Hitoshi", lastName: "Ashinano", role: "Story & Art")
        ],
        genres: [
            Genre(id: UUID(uuidString: "4C13067F-96FF-4F14-A1C0-B33215F24E0B")!, genre: "Award Winning"),
            Genre(id: UUID(uuidString: "4312867C-1359-494A-AC46-BADFD2E1D4CD")!, genre: "Drama"),
            Genre(id: UUID(uuidString: "536445E3-CEF5-49F7-B22B-6CD9807F0744")!, genre: "Slice of Life"),
            Genre(id: UUID(uuidString: "2DEDC015-82DA-4EF4-B983-F0F58C8F689E")!, genre: "Sci-Fi")
        ],
        themes: [
            Theme(id: UUID(uuidString: "263559F4-574F-4BA8-8840-2AEB445CD6BD")!, theme: "Iyashikei")
        ],
        demographics: [.seinen]
    )

    static let previewList: [Manga] = [.monster, .berserk, .twentiethCenturyBoys, .yokohamaKaidashiKikou]
}

nonisolated extension PaginatedResponse where Item == Manga {
    static let preview = PaginatedResponse(
        metadata: Metadata(total: 64833, page: 1, per: 2),
        items: Manga.previewList
    )
}
