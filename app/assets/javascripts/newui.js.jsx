/*(function(){
    HackTrack.search = function(terms, preventPushState) {
        if (! preventPushState) {
            history.pushState({action: "search", terms: terms}, null, '/new#search/'+terms);
        }

        $(".search-cell").addClass("search-cell-remove").slideUp({duration: 200}).promise().done(function() {
            $(".search-cell-remove").remove();
        });


        HackSolr.search(terms, { owners: ["2"], groups: ["everyone"] }, function(results) {
            $.each(results, function() {
                var $searchCell = $(".search-cell-template").clone();
                $searchCell.removeClass("search-cell-template");
                $searchCell.addClass("search-cell");
                $searchCell.find(".mdl-card").attr("data-id", this.path);
                $searchCell.find(".mdl-card").attr("data-title", this.title);
                $searchCell.find(".mdl-card").attr("data-category", this.category1);
                $searchCell.find(".mdl-card").attr("data-category-readable", this.category1.titleize());
                $searchCell.find(".search-title").text(this.title);
                $searchCell.find(".action1").text("Purchase");
                $searchCell.find(".action2").text("View");
                $searchCell.find(".action2").addClass("card-opener");
                $searchCell.find(".search-support-text").text(this.category1);
                $searchCell.insertAfter(".search-cell-template");

                $(".card-opener").off("click").click(function() {
                    HackTrack.open($(this.closest(".mdl-card")));
                });
            });

            $(".default-cell, .details-cell").slideUp({duration: 200}).promise().done(function() {
                $(".search-cell").slideDown(200);
            });
        });
    };

    HackTrack.back = function() {
        // This 10ms is needed otherwise the history.state info is outdated.
        setTimeout(function() {
            var state = history.state;

            if (!state || state && ! state.action) {
                HackTrack.close();
            } else if (state.action === "details") {
                HackTrack.open($("[data-id='"+state.id+"']"), true);
            } else if (state.action === "search") {
                HackTrack.search($(".hack-search").find("input").val(), true);
            }
        }, 10);
    };

    HackTrack.get = function(category, idOrCallback, optionalCallack) {
        if (typeof idOrCallback === "function") {
            var callback = idOrCallback;
            $.get(category+".json").done(function(data) {
                callback(data);
            });
        } else {
            var id = idOrCallback;
            var optionalCallack = optionalCallack;
        }
    };

    HackTrack.each = function(category, callback) {
        HackTrack.get(category, function(items) {
            $.each(items, function(index, item) {
                callback(item);
            });
        });
    };
})();
*/

function cellClass(desktop, tablet, phone) {
    var desktopClass,
        tabletClass,
        phoneClass;

    if (typeof desktop === undefined) {
        desktopClass = "";
    } else if (desktop === 0) {
        desktopClass = "mdl-cell--hide-desktop";
    } else {
        desktopClass = "mdl-cell--"+desktop+"-col-desktop";
    }

    if (typeof tablet === undefined) {
        tabletClass = "";
    } else if (tablet === 0) {
        tabletClass = "mdl-cell--hide-tablet";
    } else {
        tabletClass = "mdl-cell--"+tablet+"-col-tablet";
    }

    if (typeof phone === undefined) {
        phoneClass = "";
    } else if (phone === 0) {
        phoneClass = "mdl-cell--hide-phone";
    } else {
        phoneClass = "mdl-cell--"+phone+"-col-phone";
    }

    return "mdl-cell "+desktopClass+" "+tabletClass+" "+phoneClass;
}

class CardTitle extends React.Component {
    render() {
        return (
            <div className="mdl-card__title mdl-card--expand">
                <h2 className="mdl-card__title-text">{this.props.text}</h2>
            </div>
        );
    }
}

class CardText extends React.Component {
    render() {
        return (
            <div className="mdl-card__supporting-text">
                {this.props.text}
            </div>
        );
    }
}

class CardActions extends React.Component {
    render() {
        return (
            <div className="mdl-card__actions mdl-card--border">
                <a onClick={this.props.open} className="mdl-button mdl-button--colored">
                    Open
                </a>
            </div>
        );
    }
}

class BackButton extends React.Component {
    render() {
        return (
            <button className="mdl-button mdl-js-button mdl-button--icon back">
                <i className="material-icons" onClick={this.props.action}>arrow_back</i>
            </button>
        );
    }
}

class Card extends React.Component {
    constructor(props) {
        super(props);

        this.open = this.open.bind(this);
    }

    open() {
        // TODO manage this detailsGrid variable in the state so that we can destroy it when needed.
        var detailsGrid = <DetailsGrid tile={this.props.tile} close={this.props.closeDetailsGrid} />;
        this.props.openDetailsGrid(detailsGrid);
    }

    render() {
        return (
            <div className={cellClass(3,4,2) + "mdl-card mdl-shadow--2dp"}>
                <CardTitle text={this.props.tile.title} />
                <CardText text={this.props.tile.description}/>
                <CardActions open={this.open} />
            </div>
        );
    }
}

class Search extends React.Component {
    constructor(props) {
        super(props);

        this.search = this.search.bind(this);
    }

    componentDidMount() {
        componentHandler.upgradeElement(this.textInput);
    }

    search(e) {
        e.preventDefault();
        console.log("Doing Search");

        var exampleSearchResults = [
            {
                name: "sword",
                title: "Sword",
                description: "An awesome weapon.",
            },
            {
                name: "fireball",
                title: "Fireball",
                description: "A powerful spell.",
            }
        ];

        // TODO add closeDetailsGrid and openDetailsGrid methods.
        var searchResultCards = exampleSearchResults.map((tile) =>
            <Card tile={tile} key={tile.name} />
        );

        this.props.showSearchResults(searchResultCards);
    }

    render() {
        return (
            <form onSubmit={this.search}>
                <div className="mdl-textfield mdl-js-textfield" ref={(input) => { this.textInput = input; }}>
                    <input className="mdl-textfield__input" type="text" id="hack-search" />
                    <label className="mdl-textfield__label" htmlFor="hack-search">Search for anything...</label>
                </div>
            </form>
        )
    }
}

class DetailsGrid extends React.Component {
    render() {
        return (
            <div className="mdl-grid">
                <div className={cellClass(2,2,0)}>
                    <BackButton action={this.props.close} />
                </div>
                <div className={cellClass(2,0,0)}></div>
                <div className={cellClass(4,4,4)}>
                    <Search />
                </div>
                <div className={cellClass(4,2,0)}></div>
                <div className={cellClass(6)+" mdl-typography--display-1"}>
                    {this.props.tile.title}
                </div>
                <div className={cellClass(6)+" mdl-typography--headline"}>
                    {this.props.tile.description}
                </div>
            </div>
        );
    }
}

class HomeGrid extends React.Component {
    constructor(props) {
        super(props);

        this.state = { };
        this.state.cells = this.props.startCards;

        this.backToStart = this.backToStart.bind(this);
        this.replaceCards = this.replaceCards.bind(this);
    }

    backToStart() {
        this.setState({
            cells: this.props.startCards
        });
    }

    replaceCards(cells) {
        this.setState({
            cells: cells
        });
    }

    render() {
        return (
            <div className="mdl-grid">
                <div className={cellClass(4,0,0)}></div>
                <div className={cellClass(4,4,4)}>
                    <Search showSearchResults={this.replaceCards} />
                </div>
                <div className={cellClass(4,0,0)}></div>
                {this.state.cells}
            </div>
        );
    }
}

class Content extends React.Component {
    constructor(props) {
        super(props);
        this.state = { };

        this.openDetailsGrid = this.openDetailsGrid.bind(this);
        this.closeDetailsGrid = this.closeDetailsGrid.bind(this);

        this.state.detailsOpen = false;
    }

    openDetailsGrid(detailsGrid) {
        this.setState({
            detailsGrid: detailsGrid,
            detailsOpen: true
        });
    }

    closeDetailsGrid() {
        this.setState({
            detailsOpen: false
        });
    }

    render() {
        var grid;

        if (this.state.detailsOpen) {
            grid = this.state.detailsGrid;
        } else {
            var startCards = this.props.startTiles.map((tile) =>
                <Card tile={tile} key={tile.name}
                      closeDetailsGrid={this.closeDetailsGrid}
                      openDetailsGrid={this.openDetailsGrid} />
            );

            grid = <HomeGrid startCards={startCards} 
                             openDetailsGrid={this.openDetailsGrid}
                             closeDetailsGrid={this.closeDetailsGrid} />;
        }

        return(
            <main className="mdl-layout__content">
                {grid}
            </main>
        );
    }
}

class IconLink extends React.Component {
    render() {
        return (
          <a className="mdl-navigation__link" href={this.props.href}>
            <i className="material-icons">{this.props.icon}</i>
            Character
          </a>
        );
    }
}

class Link extends React.Component {
    render() {
        return (
            <span className="mdl-layout__link">
                <a className="mdl-navigation__link" href={this.props.href}>{this.props.title}</a>
            </span>
        );
    }
}

class Drawer extends React.Component {
    render() {
      return (
        <div className="mdl-layout__drawer">
            <span className="mdl-layout__title">{this.props.title}</span>
            <nav className="mdl-navigation characters">
              <IconLink href="/characters/step1" icon="add" />
            </nav>
        </div>
      );
    }
}


class Header extends React.Component {
    constructor(props) {
        super(props);
        this.state = { };

        this.state.characterName = "Slighter";
    }

    render() {
        return (
          <header className="mdl-layout__header">
            <div className="mdl-layout__header-row">
              <span className="mdl-layout__title">
                {this.state.characterName}
              </span>
              <div className="mdl-layout-spacer"></div>
              <Link href="/" title="Classic Version" />
            </div>
          </header>
        )
    }
}

class Layout extends React.Component {
    render() {
        return (
            <div className="mdl-layout mdl-js-layout mdl-layout--fixed-drawer mdl-layout--fixed-header mdl-color-text--grey-600 main-layout">
                <Header />
                <Drawer title={this.props.title} />
                <Content startTiles={this.props.startTiles} />
            </div>
        );
    }
}


$(document).ready(function() {
    var startTiles = [
        {
            name: "overview",
            title: "Overview",
            description: "Your characters race, class, ability scores, money, health and experience.",
        },
        {
            name: "combat",
            title: "Combat",
            description: "Your combat values and equiped weapon / armor sets.",
        },
        {
            name: "spells",
            title: "Spells",
            description: "Your spells. Lorem ipsum...",
        },
        {
            name: "equipment",
            title: "Equipment",
            description: "Your characters weapons, armor and inventory.",
        },
        {
            name: "proficiencies",
            title: "Proficiencies",
            description: "Lorem ipsum lor so todo...",
        },
        {
            name: "specializations",
            title: "Specializations",
            description: "Lorem ipsum lor so todo...",
        },
        {
            name: "talents",
            title: "Talents",
            description: "Lorem ipsum lor so todo...",
        },
        {
            name: "skills",
            title: "Skills",
            description: "Your talents, proficiencies, skills, and .",
        }
    ];

    var layout = <Layout startTiles={startTiles} title="Hacktrack" />;
    ReactDOM.render(layout, document.getElementById('react-root'));
});
