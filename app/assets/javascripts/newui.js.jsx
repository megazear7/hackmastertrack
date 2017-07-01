(function(){
    window.HackTrack = {};

    HackTrack.open = function($card, preventPushState) {
        var data = $card.data();
        var category = data.category;
        var title = data.title;

        if (! preventPushState) {
            history.pushState({action: "details", category: category, id: data.id}, null, '/new#details/'+category+"/"+title);
        }

        $(".details-title").text(data.title.titleize());

        if (data.categoryReadable) {
            $(".details-category").text(data.categoryReadable);
        }

        $(".default-cell, .search-cell").slideUp({duration: 200}).promise().done(function() {
            $(".details-cell").slideDown(200);
        });
    };

    HackTrack.close = function() {
        $(".details-cell, .search-cell").slideUp({duration: 200}).promise().done(function() {
            $(".default-cell").slideDown(200);
        });
    };

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

/*
$(document).ready(function() {
    history.pushState({}, null, '/new#');

    var $characters = $(".characters");
    HackTrack.each("characters", function(character) {
        var $character = $("<a class='mdl-navigation__link character' href='#"+character.id+"'></a>");
        $character.data(character);
        $character.text(character.name);
        $characters.prepend($character);

        $character.click(function() {
            $(".character-name").text(character.name);
            $(".character").removeClass("mdl-navigation__link--current");
            $character.addClass("mdl-navigation__link--current");
        });
    });

    $(".card-opener").off("click").click(function() {
        HackTrack.open($(this.closest(".mdl-card")));
    });

    $(".back").click(function() {
        history.back();
    });

    $(".hack-search").submit(function(e) {
        e.preventDefault();
        HackTrack.search($(this).find("input").val());
    });

    window.addEventListener('popstate', function() {
        HackTrack.back();
    });
});
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
                <a onClick={this.props.open}
                   className="card-opener mdl-button mdl-button--colored">
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

class Search extends React.Component {
    componentDidMount() {
        componentHandler.upgradeElement(this.textInput);
    }

    render() {
        return (
            <form className="hack-search">
                <div className="mdl-textfield mdl-js-textfield hack-search" ref={(input) => { this.textInput = input; }}>
                    <input className="mdl-textfield__input" type="text" id="sample1" />
                    <label className="mdl-textfield__label" htmlFor="sample1">Search for anything...</label>
                </div>
            </form>
        )
    }
}

class DetailsGrid extends React.Component {
    render() {
        return (
            <div className="mdl-grid" id="hack-main-grid">
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
            <div className="mdl-card mdl-shadow--2dp" title="combat" data-category-readable="Character Details" data-category="character_info" data-id="/character_info/combat">
                <CardTitle text={this.props.tile.title} />
                <CardText text={this.props.tile.description}/>
                <CardActions open={this.open} />
            </div>
        );
    }
}

class Cell extends React.Component {
    constructor(props) {
        super(props);
    }


    render() {
        return (
            <div className={cellClass(3,4,2) + " default-cell"}>
                <Card tile={this.props.tile} closeDetailsGrid={this.props.closeDetailsGrid} openDetailsGrid={this.props.openDetailsGrid} />
            </div>
        );
    }
}

class SearchGrid extends React.Component {
    render() {
        return (
            <div className="mdl-grid" id="hack-main-grid">
                {cellComponents}
            </div>
        );
    }
}

class ContentLayout extends React.Component {
    constructor(props) {
        super(props);
        this.state = { };

        this.openDetailsGrid = this.openDetailsGrid.bind(this);
        this.closeDetailsGrid = this.closeDetailsGrid.bind(this);

        this.state.tiles = props.tiles;
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
            cellComponents = this.props.tiles.map((tile) =>
                <Cell tile={tile} key={tile.name} closeDetailsGrid={this.closeDetailsGrid} openDetailsGrid={this.openDetailsGrid} />
            );
            grid = <SearchGrid cellComponents={cellComponents} />;
        }

        return(
            <main className="mdl-layout__content">
                {grid}
            </main>
        );
    }
}

$(document).ready(function() {
    var tiles = [
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

    var contentLayout = <ContentLayout tiles={tiles} />;
    ReactDOM.render(contentLayout, document.getElementById('react-root'));
});

Array.prototype.remove = function() {
    var what, a = arguments, L = a.length, ax;
    while (L && this.length) {
        what = a[--L];
        while ((ax = this.indexOf(what)) !== -1) {
            this.splice(ax, 1);
        }
    }
    return this;
};

String.prototype.capitalize = function() {
    return this.charAt(0).toUpperCase() + this.slice(1);
}

String.prototype.titleize = function() {
    var string_array = this.split(' ');
    string_array = string_array.map(function(str) {
       return str.capitalize(); 
    });
    
    return string_array.join(' ');
}
