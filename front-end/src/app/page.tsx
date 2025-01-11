import ArticleSectionConteiner from "./(ArticlesSection)/SectionConteiner";
import SearchSection from "./(SearchSection)/SearchSection";

export default function Home() {
  return (
    <main className="HomePage flex w-[80vw] min-h-[100vh] pt-[50px] align-middle flex-col items-center ">
      <SearchSection/>
      <ArticleSectionConteiner/>
      
    </main>
  );
}


