//
//  ModelTests.swift
//  ModelTests
//
//  Created by Josimar Revelo on 21/08/26.
//

import Testing
import Foundation
@testable import MangaShelf

struct ModelTests {
    
    @Test func decodeMangaFromAPIResponse() throws {
        let json = """
        {"score":9.15,"status":"finished","titleEnglish":"Monster","background":"Monster won the Grand Prize at the 3rd annual Tezuka Osamu Cultural Prize in 1999, as well as the 46th Shogakukan Manga Award in the General category in 2000. The series was published in English by VIZ Media under the VIZ Signature imprint from February 21, 2006 to December 16, 2008, and again in 2-in-1 omnibuses (subtitled The Perfect Edition) from July 15, 2014 to July 19, 2016. The manga was also published in Brazilian Portuguese by Panini Comics/Planet Manga from June 2012 to April 2015, in Polish by Hanami from March 2014 to February 2017, in Spain by Planeta Cómic from June 16, 2009 to September 21, 2010, and in Argentina by LARP Editores.","demographics":[{"demographic":"Seinen","id":"CE425E7E-C7CD-42DB-ADE3-1AB9AD16386D"}],"sypnosis":"Kenzou Tenma, a renowned Japanese neurosurgeon working in post-war Germany, faces a difficult choice: to operate on Johan Liebert, an orphan boy on the verge of death, or on the mayor of Düsseldorf. In the end, Tenma decides to gamble his reputation by saving Johan, effectively leaving the mayor for dead.\\n\\nAs a consequence of his actions, hospital director Heinemann strips Tenma of his position, and Heinemann's daughter Eva breaks off their engagement. Disgraced and shunned by his colleagues, Tenma loses all hope of a successful career—that is, until the mysterious killing of Heinemann gives him another chance.\\n\\nNine years later, Tenma is the head of the surgical department and close to becoming the director himself. Although all seems well for him at first, he soon becomes entangled in a chain of gruesome murders that have taken place throughout Germany. The culprit is a monster—the same one that Tenma saved on that fateful day nine years ago.\\n\\n[Written by MAL Rewrite]","authors":[{"role":"Story & Art","firstName":"Naoki","id":"54BE174C-2FE9-42C8-A842-85D291A6AEDD","lastName":"Urasawa"}],"chapters":162,"endDate":"2001-12-20T00:00:00Z","themes":[{"theme":"Adult Cast","id":"840867E7-6C60-49CE-8C47-A99AA71A2113"},{"theme":"Psychological","id":"4394C99F-615B-494A-929E-356A342A95B8"}],"startDate":"1994-12-05T00:00:00Z","id":1,"titleJapanese":"MONSTER","url":"https://myanimelist.net/manga/1/Monster","title":"Monster","volumes":18,"genres":[{"id":"4C13067F-96FF-4F14-A1C0-B33215F24E0B","genre":"Award Winning"},{"id":"4312867C-1359-494A-AC46-BADFD2E1D4CD","genre":"Drama"},{"id":"97C8609D-856C-419E-A4ED-E13A5C292663","genre":"Mystery"}],"mainPicture":"https://cdn.myanimelist.net/images/manga/3/258224l.jpg"}
        """.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        let manga = try decoder.decode(Manga.self, from: json)
        
        #expect(manga.id == 1)
        #expect(manga.title == "Monster")
        #expect(manga.synopsis != nil)
        #expect(manga.authors.first?.lastName == "Urasawa")
        #expect(manga.genres.count == 3)
        #expect(manga.demographics.first == .seinen)
    }

}
