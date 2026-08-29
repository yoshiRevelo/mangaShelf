//
//  MangaShelfTests.swift
//  MangaShelfTests
//
//  Created by Josimar Revelo on 28/08/26.
//

import Testing
@testable import MangaShelf

@Suite("ListViewModelTests")
struct MangaShelfTests {

    @Test func fetchMangas() async {
        let viewModel = await MangasListViewModel(repository: MockMangaRepository())
        await viewModel.loadMangas()
        #expect(await viewModel.mangas.count == 2)
    }
    
    @Test func stopFetchAtSecondCall() async {
        let viewModel = await MangasListViewModel(repository: MockMangaRepository(delay: .milliseconds(100)))
        async let first = await viewModel.loadMangas()
        async let second = await viewModel.loadMangas()
        
        _ = await (first, second)
        
        #expect(await viewModel.mangas.count == 2)
    }

    @Test func errorState() async {
        let viewModel = await MangasListViewModel(repository: MockMangaRepository(shouldFail: true))
        await viewModel.loadMangas()
        
        guard case .error = await viewModel.listState else {
            Issue.record("Must be an error, we got \(await viewModel.listState)")
            return
        }
    }
}
