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

    static let previewList: [Manga] = [.monster, .berserk]
}

nonisolated extension PaginatedResponse where Item == Manga {
    static let preview = PaginatedResponse(
        metadata: Metadata(total: 64833, page: 1, per: 2),
        items: Manga.previewList
    )
}
