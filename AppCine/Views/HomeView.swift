//
//  HomeView.swift
//  AppCine
//
//  Created by Jacob Aguilar on 07-02-22.
//

import SwiftUI
import Kingfisher

struct HomeView: View {
    
    var body: some View {
        
        GeometryReader { geometry in
            ZStack {
                Color("BackgroundColor")
                    .ignoresSafeArea()
                
                VStack {
                    Image("logo")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 80, height: 80, alignment: .center)
                    
                    HomeSubModuleView()
                    
                    Spacer()
                    
                }
                .padding(.horizontal, 10)
            }
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}


struct HomeSubModuleView: View {
    
    @State var searchText: String = ""
    @State var currentTab: String = "Popular"
    @State var isPopularButtonSelected: Bool = true
    @State var isUpcomingButtonSelected: Bool = false
    @State var isTopRatedButtonSelected: Bool = false
    @Namespace var animation
    
    var body: some View {
        
        VStack {
            
            HStack {
                Button {
                    //Do something
                } label: {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(searchText.isEmpty ? .gray : Color("ButtonsColor"))
                        .font(.system(size: 20))
                }
            
                ZStack(alignment: .leading) {
                    if searchText.isEmpty {
                        Text("Search movies")
                            .foregroundColor(.gray)
                            .font(.body)
                            .padding(.leading, 5)
                    }
                    
                    TextField("", text: $searchText)
                        .foregroundColor(.white)
                }
                
                Button {
                    withAnimation(Animation.spring()) {
                        searchText = ""
                    }
                } label: {
                    Image(systemName: "xmark")
                        .foregroundColor(searchText.isEmpty ? .gray : Color("ButtonsColor"))
                        .font(.system(size: 20))
                }

            }
            .padding()
            .background(Color("TextFieldColor"))
            .clipShape(Capsule())
            
            VStack(alignment: .center) {
                HStack(spacing: 0) {
                    
                    TabButton(title: "Popular", animation: animation, currentTab: $currentTab)
                        
                    TabButton(title: "Upcoming", animation: animation, currentTab: $currentTab)
                        
                    TabButton(title: "Top Rated", animation: animation, currentTab: $currentTab)
                    
                }
                .frame(maxWidth: .infinity)
                .cornerRadius(12)
                
                if currentTab == "Popular" {
                    withAnimation(Animation.spring()) {
                        PopularMoviesInfoView()
                            .transition(.move(edge: .bottom))
                    }
                }
                
                if currentTab == "Upcoming" {
                    withAnimation(Animation.spring()) {
                        UpcomingrMoviesInfoView()
                            .transition(.move(edge: .bottom))
                    }
                }
                
                if currentTab == "Top Rated" {
                    withAnimation(Animation.spring()) {
                        TopRatedMoviesInfoView()
                            .transition(.move(edge: .bottom))
                    }
                }
                
                
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            
        }
        
    }
}


struct TabButton: View {
    
    var title: String
    var animation: Namespace.ID
    @Binding var currentTab: String
    
    var body: some View{
        
        VStack {
            Button {
                withAnimation(.spring()){
                    currentTab = title
                }
                
            } label: {
                
                Text(title)
                    .foregroundColor(currentTab == title ? .white : .gray)
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 6)
                    .background(
                        ZStack{
                            if currentTab == title{
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(
                                        LinearGradient(gradient: Gradient(colors: [Color("ButtonsColor"), Color("ButtonsSecondaryColor")]), startPoint: .leading, endPoint: .trailing)
                                    )
                                    .matchedGeometryEffect(id: "TAB", in: animation)
                            }
                        }
                    )
            }
            
            
        }
        

    }
}


struct PopularMoviesInfoView: View {
    
    @ObservedObject var moviesViewModel: PopularMoviesViewModel = PopularMoviesViewModel()
    @State var title: String = ""
    @State var imgUrl: String = ""
    @State var overview: String = ""
    @State var releaseDate: String = ""
    @State var movieID: Int = 0
    @State var isMovieDetailPressed: Bool = false
    @State var isShowDetailPage: Bool = false
    @Namespace var animation
    let gridForm = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: gridForm) {
                    ForEach(moviesViewModel.moviesModel?.results ?? [], id: \.self) { movie in
                        Button {
                            isMovieDetailPressed.toggle()
                            title = movie.title!
                            overview = movie.overview!
                            releaseDate = movie.releaseDate!
                            imgUrl = moviesViewModel.imgUrl + movie.posterPath!
                            movieID = movie.id!
                        } label: {
                            
                            VStack {
                                
                                KFImage(URL(string: moviesViewModel.imgUrl + movie.posterPath!))
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .cornerRadius(15)
                                
                                VStack {
                                    
                                    Text(movie.title!)
                                        .foregroundColor(.white)
                                        .font(.system(size: 15, weight: .bold, design: .rounded))
                                        .frame(maxWidth: 120, maxHeight: 20)
                                    
                                    HStack(spacing: 2) {
                                        
                                        Text("Release date: ")
                                            .foregroundColor(.gray)
                                            .font(.system(size: 12, design: .rounded))
                                        
                                        Text(movie.releaseDate!)
                                            .foregroundColor(.white)
                                            .font(.system(size: 11, design: .rounded))
                                    }
                                    .padding(.top, 2)
                                    .padding(.bottom, 10)
                                }
                                
                            }
                            .background(Color("CardColor"))
                            .cornerRadius(15)
                            
                        }
                        .padding(.top, 10)
                        .padding(.bottom, 20)
//                        .sheet(isPresented: $isMovieDetailPressed) {
//                            MovieDetailView(title: title, overview: overview, releaseDate: releaseDate, imgURL: imgUrl)
//                        }
                    }
                    
                }
            }
            .cornerRadius(15)
        }
        .ignoresSafeArea(edges: .bottom)
        .padding(.horizontal, 10)
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        NavigationLink(isActive: $isMovieDetailPressed) {
            MovieDetailView(title: title, overview: overview, releaseDate: releaseDate, imgURL: imgUrl, movieID: movieID)
                .transition(AnyTransition.scale)
        } label: {
            EmptyView()
        }
    }
}


struct UpcomingrMoviesInfoView: View {
    
    @ObservedObject var moviesViewModel: UpcomingMoviesViewModel = UpcomingMoviesViewModel()
    @State var title: String = ""
    @State var imgUrl: String = ""
    @State var overview: String = ""
    @State var releaseDate: String = ""
    @State var movieID: Int = 0
    @State var isMovieDetailPressed: Bool = false
    let gridForm = [GridItem(.flexible()), GridItem(.flexible())]
    
    
    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: gridForm) {
                    ForEach(moviesViewModel.moviesModel?.results ?? [], id: \.self) { movie in
                        Button {
                            title = movie.title!
                            overview = movie.overview!
                            releaseDate = movie.releaseDate!
                            imgUrl = moviesViewModel.imgUrl + movie.posterPath!
                            isMovieDetailPressed.toggle()
                            movieID = movie.id!
                        } label: {
                            
                            VStack {
                                
                                KFImage(URL(string: moviesViewModel.imgUrl + movie.posterPath!))
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .cornerRadius(15)
                                
                                VStack {
                                    
                                    Text(movie.title!)
                                        .foregroundColor(.white)
                                        .font(.system(size: 15, weight: .bold, design: .rounded))
                                        .frame(maxWidth: 120, maxHeight: 20)
                                    
                                    HStack(spacing: 2) {
                                        
                                        Text("Release date: ")
                                            .foregroundColor(.gray)
                                            .font(.system(size: 12, design: .rounded))
                                        
                                        Text(movie.releaseDate!)
                                            .foregroundColor(.white)
                                            .font(.system(size: 11, design: .rounded))
                                    }
                                    .padding(.top, 2)
                                    .padding(.bottom, 10)
                                }
                                
                            }
                            .background(Color("CardColor"))
                            .cornerRadius(15)
                            
                        }
                        .padding(.top, 10)
                        .padding(.bottom, 20)
//                        .sheet(isPresented: $isMovieDetailPressed) {
//                            MovieDetailView(title: title, overview: overview, releaseDate: releaseDate, imgURL: imgUrl)
//                        }
                    }
                    
                }
            }
            .cornerRadius(15)
        }
        .ignoresSafeArea(edges: .bottom)
        .padding(.horizontal, 10)
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        NavigationLink(isActive: $isMovieDetailPressed) {
            MovieDetailView(title: title, overview: overview, releaseDate: releaseDate, imgURL: imgUrl, movieID: movieID)
                .transition(AnyTransition.scale)
        } label: {
            EmptyView()
        }
    }
}


struct TopRatedMoviesInfoView: View {
    
    @ObservedObject var moviesViewModel: TopRatedMoviesViewModel = TopRatedMoviesViewModel()
    @State var title: String = ""
    @State var imgUrl: String = ""
    @State var overview: String = ""
    @State var releaseDate: String = ""
    @State var movieID: Int = 0
    @State var isMovieDetailPressed: Bool = false
    let gridForm = [GridItem(.flexible()), GridItem(.flexible())]
    
    
    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: gridForm) {
                    ForEach(moviesViewModel.moviesModel?.results ?? [], id: \.self) { movie in
                        Button {
                            title = movie.title!
                            overview = movie.overview!
                            releaseDate = movie.releaseDate!
                            imgUrl = moviesViewModel.imgUrl + movie.posterPath!
                            isMovieDetailPressed.toggle()
                            movieID = movie.id!
                        } label: {
                            
                            VStack {
                                
                                KFImage(URL(string: moviesViewModel.imgUrl + movie.posterPath!))
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .cornerRadius(15)
                                
                                VStack {
                                    
                                    Text(movie.title!)
                                        .foregroundColor(.white)
                                        .font(.system(size: 15, weight: .bold, design: .rounded))
                                        .frame(maxWidth: 120, maxHeight: 20)
                                    
                                    HStack(spacing: 2) {
                                        
                                        Text("Release date: ")
                                            .foregroundColor(.gray)
                                            .font(.system(size: 12, design: .rounded))
                                        
                                        Text(movie.releaseDate!)
                                            .foregroundColor(.white)
                                            .font(.system(size: 11, design: .rounded))
                                    }
                                    .padding(.top, 2)
                                    .padding(.bottom, 10)
                                }
                                
                            }
                            .background(Color("CardColor"))
                            .cornerRadius(15)
                            
                        }
                        .padding(.top, 10)
                        .padding(.bottom, 20)
//                        .sheet(isPresented: $isMovieDetailPressed) {
//                            MovieDetailView(title: title, overview: overview, releaseDate: releaseDate, imgURL: imgUrl)
//                        }

                    }
                    
                }
            }
            .cornerRadius(15)
        }
        .ignoresSafeArea(edges: .bottom)
        .padding(.horizontal, 10)
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        NavigationLink(isActive: $isMovieDetailPressed) {
            MovieDetailView(title: title, overview: overview, releaseDate: releaseDate, imgURL: imgUrl, movieID: movieID)
                .transition(AnyTransition.scale)
        } label: {
            EmptyView()
        }
    }
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

