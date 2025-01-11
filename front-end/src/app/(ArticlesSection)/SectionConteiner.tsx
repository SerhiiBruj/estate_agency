import ArticleCard from "./ArticleCard";



function ArticleSectionConteiner() {

    return (
        <>





            <div style={{overflowX: "scroll"}} className="grid grid-cols-8  overflow-x-scroll w-fit ">
                <ArticleCard />
                <ArticleCard />
                <ArticleCard />
                <ArticleCard />
                <ArticleCard />
                <ArticleCard />
                <ArticleCard />
                <ArticleCard />
                <ArticleCard />
                <ArticleCard />
                <ArticleCard />
            </div>

        </>
    )
}


export default ArticleSectionConteiner;

