#include "gameboardmodel.h"

GameBoardModel::GameBoardModel(QObject* parent)
    : QAbstractListModel(parent)
    , m_board(new GameBoard(this))
{
    connect(m_board, &GameBoard::dataChanged, this, [this]() {
        emit dataChanged(index(0, 0), index(m_board->boardSize() - 1, 0));
    });
    connect(m_board, &GameBoard::dimensionChanged, this, &GameBoardModel::dimensionChanged);
    connect(m_board, &GameBoard::counterChanged, this, &GameBoardModel::counterChanged);
    connect(m_board, &GameBoard::boardSizeChanged, this, &GameBoardModel::boardSizeChanged);
    connect(m_board, &GameBoard::gameWon, this, &GameBoardModel::gameWon);
}

int GameBoardModel::rowCount(const QModelIndex& parent) const
{
    return m_board->rowCount(parent);
}

QVariant GameBoardModel::data(const QModelIndex& index, int role) const
{
    return m_board->data(index, role);
}

int GameBoardModel::boardSize() const
{
    return m_board->boardSize();
}

int GameBoardModel::dimension() const
{
    return m_board->dimension();
}

void GameBoardModel::setDimension(int dim)
{
    m_board->setDimension(dim);
}

int GameBoardModel::hiddenElementValue() const
{
    return m_board->boardSize();
}

int GameBoardModel::counter() const
{
    return m_board->counter();
}

bool GameBoardModel::move(int index)
{
    return m_board->move(index);
}

bool GameBoardModel::checkWin() const
{
    return m_board->checkWin();
}

void GameBoardModel::resetBoard()
{
    m_board->resetBoard();
}
